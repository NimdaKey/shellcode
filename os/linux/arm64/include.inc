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

        // symbolic constants for Linux/AArch64
        .equ BUFSIZ,               64
        .equ NULL,                  0
        .equ SIGCHLD,              17
        .equ CLONE_CHILD_CLEARTID, 0x00200000
        .equ CLONE_CHILD_SETTID,   0x01000000

        .equ SHUT_RDWR,            2

        .equ STDIN_FILENO,         0
        .equ STDOUT_FILENO,        1
        .equ STDERR_FILENO,        2

        .equ AF_INET,              2
        .equ SOCK_STREAM,          1
        .equ IPPROTO_IP,           0

        .equ EPOLLIN,              1

        .equ EPOLL_CTL_ADD,        1
        .equ EPOLL_CTL_DEL,        2
        .equ EPOLL_CTL_MOD,        3

        // system calls
        .equ SYS_epoll_create1,   20    
        .equ SYS_epoll_ctl,       21 
        .equ SYS_epoll_pwait,     22    
        .equ SYS_dup3,            24
        .equ SYS_close,           57 
        .equ SYS_pipe2,           59    
        .equ SYS_read,            63 
        .equ SYS_write,           64 
        .equ SYS_exit,            93 
        .equ SYS_kill,           129 
        .equ SYS_gettid,         178
        .equ SYS_socket,         198 
        .equ SYS_bind,           200 
        .equ SYS_listen,         201
        .equ SYS_accept,         202
        .equ SYS_connect,        203
        .equ SYS_shutdown,       210
        .equ SYS_clone,          220
        .equ SYS_execve,         221
