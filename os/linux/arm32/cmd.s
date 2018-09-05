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
  
    .arch armv6
    
    .include "include.inc"
    
    .global _start
    .text

_start:
    .code 32
    ldr    r1, =#0x6e69622f // /bin
    ldr    r2, =#0x68732f2f // //sh
    ldr    r4, =#0xffff9cd2 // -c
    mvn    r4, r4 

    // switch to thumb mode    
    add    r0, pc, #1
    bx     r0
    
    .code 16
    // execve("/bin/sh", {"/bin/sh", "-c", cmd, NULL}, NULL);
    eor    r3, r3         // r3 = NULL
    push   {r1, r2, r3}
    mov    r0, sp         // r0 = "/bin/sh"
    
    push   {r4}
    mov    r1, sp         // r1 = "-c"
    
    adr    r2, cmd        // r4 = cmd
    
    push   {r0, r1, r2, r3}
    eor    r2, r2         // penv = NULL
    mov    r1, sp         // r1 = argv
    mov    r7, #11        // r7 = execve
    svc    1  
    nop
cmd:
    .ascii "echo Hello, World!"

