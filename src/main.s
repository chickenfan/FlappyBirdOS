.global start
.section .text

start:
	mov ah, 0x0e
	mov al, '!'
	int 0x10
