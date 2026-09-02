.PHONY: build lib
.DEFAULT_GOAL := build

lib:
	nasm -f elf64 -i ./include -o build/libsock.o src/lib/sock.asm
	ld -shared -o build/libsock.so build/libsock.o

build:
	nasm -f elf64 -i ./include -o build/libsock.o src/lib/sock.asm
	ar rcs lib/libsock.a build/libsock.o
	gcc -o bin/main src/main.c -L lib -l sock


