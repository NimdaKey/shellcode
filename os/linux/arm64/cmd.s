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
    // execve("/bin/sh", {"/bin/sh", "-c", cmd, NULL}, NULL);
    adr    x0, sh                // x0 = "/bin/sh"
    adr    x1, c_arg             // x1 = "-c"
    adr    x2, cmd               // x2 = cmd
    // store pair works with the 2nd parameter first
    // stack must be aligned
    stp    x2, xzr, [sp, #-16]!  // store cmd, NULL
    stp    x0, x1,  [sp, #-16]!  // store "-c", "/bin/sh"
    mov    x2, xzr               // penv = NULL
    mov    x1, sp                // x1 = argv
    mov    x8, #SYS_execve
    svc    0  
sh:    
    .asciz "/bin/sh"
c_arg:
    .asciz "-c"
cmd:
    .asciz "echo Hello, World!"

