.code16
.org 0

.section .text

loop:
	jmp loop

.align 16
gdt_start:
gdt_null:
    .quad 0
gdt_code_segment:
    	.word 0xffff
    	.word 0x0000
	.byte 0x00
	.byte 0b10011010
	.byte 0b11001111
	.byte 0x00
gdt_data_segment:
	.word 0xffff
	.word 0x0000
	.byte 0x00
	.byte 0b10010010
	.byte 0b11001111
	.byte 0x00
gdt_end:

gdtp:
	.word gdt_end - gdt_start - 1
	.long gdt_start

.org 510

.word 0xaa55
