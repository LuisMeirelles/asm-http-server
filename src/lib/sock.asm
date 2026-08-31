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

  mensagem_erro_socket db  "erro socket"
  .len: equ $ - mensagem_erro_socket

  mensagem_erro_bind db  "erro bind"
  .len: equ $ - mensagem_erro_bind
  
  mensagem_erro_listen db  "erro listen"
  .len: equ $ - mensagem_erro_listen

  mensagem_erro_accept db  "erro accept"
  .len: equ $ - mensagem_erro_accept

section .bss
  align 4

  addr_client: resb sockaddr_in_size

section .text
  global listen
  default rel

; void fatal_error(uint16_t buf, uint16_t, len, uint16_t exit_code)
fatal_error:
  MOV r12, rdi
  MOV r13, rsi
  MOV r14, rdx

  WRITE STDERR, r12, r13
  EXIT r14

; int listen(uint16_t port);
listen:
  PUSH r12

  ; passa o parâmetro `port` para addr_in.sin_port (big endian)
  MOV cx, di
  ROL cx, 8

  MOV word [addr_in + 2], cx

  ; cria o socket, retornando o file descriptor em %rax
  SOCKET_CREATE
  
  MOV r12, rax

  CMP rax, 0
  JGE endif_socket
    LEA rdi, [mensagem_erro_socket]
    MOV rsi, mensagem_erro_socket.len
    MOV rdx, rax

    CALL fatal_error

  endif_socket:

  BIND_SOCKET r12, addr_in, sockaddr_in_size

  CMP rax, 0
  JGE endif_bind
    LEA rdi, [mensagem_erro_bind]
    MOV rsi, mensagem_erro_bind.len
    MOV rdx, rax

    CALL fatal_error

  endif_bind:

  LISTEN_SOCKET r12, 3

  CMP rax, 0
  JGE endif_listen
    LEA rdi, [mensagem_erro_listen]
    MOV rsi, mensagem_erro_listen.len
    MOV rdx, rax

    CALL fatal_error

  endif_listen:

  ; %rax = client fd
  ACCEPT r12, addr_client, client_len

  CMP rax, 0
  JGE endif_accept
    LEA rdi, [mensagem_erro_accept]
    MOV rsi, mensagem_erro_accept.len
    MOV rdx, rax

    CALL fatal_error

  endif_accept:

  POP r12

  RET

section .note.GNU-stack

