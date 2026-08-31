%include "constants.inc"

%define SYS_SOCKET  41
%define SYS_BIND    49
%define SYS_LISTEN  50
%define SYS_ACCEPT  43
%define SYS_WRITE   1
%define SYS_EXIT    60

%macro SOCKET_CREATE 0
  MOV rax, SYS_SOCKET
  MOV rdi, AF_INET
  MOV rsi, SOCK_STREAM
  MOV rdx, 0 ; socket protocol 0 = default for domain
  SYSCALL
%endmacro

%macro BIND_SOCKET 3
  MOV rax, SYS_BIND
  MOV rdi, %1
  LEA rsi, [%2]
  MOV rdx, %3
  SYSCALL
%endmacro

%macro LISTEN_SOCKET 2
  MOV rax, SYS_LISTEN
  MOV rdi, %1
  MOV rsi, %2
  SYSCALL
%endmacro

%macro ACCEPT 3
  MOV rax, SYS_ACCEPT
  MOV rdi, %1
  LEA rsi, [%2]
  LEA rdx, [%3]
  SYSCALL
%endmacro

%macro WRITE 3
  MOV rax, SYS_WRITE ; write syscall

  MOV rdi, %1 ; file descriptor
  MOV rsi, %2 ; buffer
  MOV rdx, %3 ; count

  SYSCALL
%endmacro

%macro EXIT 1
  MOV rdi, %1
  MOV rax, SYS_EXIT ; exit syscall

  SYSCALL
%endmacro

