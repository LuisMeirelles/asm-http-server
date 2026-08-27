%define SYS_SOCKET  41
%define AF_INET     2
%define SOCK_STREAM 2

%define SYS_BIND    49

struc sockaddr_in
    .sin_family:  resw 1    
    .sin_port:    resw 1    
    .sin_addr:    resd 1    
    .sin_zero:    resb 8
endstruc                   

section .data
  align 4

  addr:
    istruc sockaddr_in
      at sockaddr_in.sin_family,  dw  AF_INET
      at sockaddr_in.sin_port,    dw  0x401f  ; 8000 big endian
      at sockaddr_in.sin_addr,    dd  0       ; INADDR_ANY big endian
      at sockaddr_in.sin_zero,    times 8 db 0
    iend

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
  MOV rdi, rax
  MOV rax, SYS_BIND
  MOV rsi, addr
  MOV rdx, sockaddr_in_size
  SYSCALL

  RET

section .note.GNU-stack

