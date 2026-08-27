%define SYS_SOCKET  41
%define AF_INET     2
%define SOCK_STREAM 2

section .text
  global sock
  default rel

sock:
  ; cria o socket, retornando o file descriptor em %rax
  MOV rax, SYS_SOCKET
  MOV rdi, AF_INET
  MOV rsi, SOCK_STREAM
  MOV rdx, 0 ; socket protocol 0 = default for domain
  SYSCALL

  ; bind socket

  RET

section .note.GNU-stack

