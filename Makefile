.PHONY: build
.DEFAULT_GOAL := build

build:
	nasm -f elf64 -o build/libsock.o src/lib/sock.asm
	ar rcs lib/libsock.a build/libsock.o
	gcc -o bin/main src/main.c -L lib -l sock


