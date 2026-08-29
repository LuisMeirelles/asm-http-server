%include "syscalls.inc"

struc sockaddr_in
    .sin_family:  resw 1
    .sin_port:    resw 1  ; big endian
    .sin_addr:    resd 1  ; big endian
    .sin_zero:    resb 8
endstruc

section .data
  align 4

  addr_in:
    istruc sockaddr_in
      at sockaddr_in.sin_family,  dw  AF_INET
      at sockaddr_in.sin_port,    dw  0
      at sockaddr_in.sin_addr,    dd  INADDR_ANY
      at sockaddr_in.sin_zero,    times 8 db 0
    iend

  client_len: dd sockaddr_in_size

section .bss
  align 4

  addr_client: resb sockaddr_in_size

section .text
  global listen
  default rel

; int listen(uint16_t port);
listen:
  ; passa o parâmetro `port` para addr_in.sin_port (big endian)
  MOV cx, di
  ROL cx, 8

  MOV word [addr_in + 2], cx

  ; cria o socket, retornando o file descriptor em %rax
  SOCKET_CREATE

  ; salva rax = socket fd
  MOV r12, rax

  ; bind socket
  BIND_SOCKET r12, addr_in, sockaddr_in_size

  ; listen
  LISTEN_SOCKET r12, 3

  ; accept
  MOV rax, SYS_ACCEPT
  MOV rdi, r12
  LEA rsi, [addr_client]
  LEA rdx, [client_len]
  SYSCALL

  ; returns client fd
  RET

section .note.GNU-stack

