%include "syscalls.inc"

%define ORIGEM_SOCKET 0x0100
%define ORIGEM_BIND   0x0200
%define ORIGEM_LISTEN 0x0300
%define ORIGEM_ACCEPT 0x0400

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

  mensagem_erro_socket db  "erro socket", 0x0A
  .len: equ $ - mensagem_erro_socket

  mensagem_erro_bind db  "erro bind", 0x0A
  .len: equ $ - mensagem_erro_bind
  
  mensagem_erro_listen db  "erro listen", 0x0A
  .len: equ $ - mensagem_erro_listen

  mensagem_erro_accept db  "erro accept", 0x0A
  .len: equ $ - mensagem_erro_accept

section .bss
  align 4

  addr_client: resb sockaddr_in_size
  
  buf resb 1024
  .len: equ $ - buf

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


; int strlen(const char *string)
strlen:
  XOR rcx, rcx ; size_t count = 0

  .loop: ; while (1)
    MOVZX ebx, byte [rdi] ; char character = *string

    CMP bl, 0 ; if (character == '\0')
    JE .end_strlen ; break

    INC rcx

    ; string++
    ; MOV rdi, rsi
    INC rdi

    JMP .loop

  .end_strlen:
    MOV rax, rcx ; size_t value = count
    RET ; return value

; int listen(uint16_t port, char *(*handler)(char*))
listen:
  PUSH r12
  PUSH r13
  PUSH r14
  PUSH r15

  PUSH rsi

  ; passa o parâmetro `port` para addr_in.sin_port (big endian)
  MOV cx, di
  ROL cx, 8

  MOV word [addr_in + 2], cx

  SOCKET_CREATE
 
  ; %r12 = server_fd
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

  ACCEPT r12, addr_client, client_len

  ; %r13 = client_fd
  MOV r13, rax

  CMP rax, 0
  JGE endif_accept
    LEA rdi, [mensagem_erro_accept]
    MOV rsi, mensagem_erro_accept.len
    MOV rdx, rax

    CALL fatal_error

  endif_accept:

  ; %r14 = endereço efetivo do buffer
  LEA r14, [buf]

  READ r13, r14, buf.len

  MOV rdi, r14
  POP rax
  CALL rax

  ; %r14 = retorno do handler
  MOV r14, rax

  MOV rdi, r14
  CALL strlen

  ; %r15 tamanho do retorno do handler
  MOV r15, rax

  WRITE r13, r14, r15

  POP r15
  POP r14
  POP r13
  POP r12

  RET

section .note.GNU-stack

