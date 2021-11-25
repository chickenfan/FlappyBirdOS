.code16
.org 0

.section .text
.global BOOT_DRIVE
.global HEX_OUT

loop:
	jmp loop

read_disk:
	mov $2, %ah
	mov $0, %dl
	mov $3, %ch
	mov $1, %dh
	mov $4, %cl
	mov $5, %al
	mov $0xa000, %bx
	mov %bx, %es
	mov $0x1234, %bx
	int 0x13
	jc disk_error_print
	pop %dx
	cmp %al, %dh
	jne disk_error_print
	ret

read_sectors_from_disk:
	mov %dl, (BOOT_DRIVE)
	mov $0x8000, %bp
	mov %bp, %sp
	mov $0x9000, %bx
	mov $5, %dh
	mov (BOOT_DRIVE), %dl
	call read_disk
	mov ($0x9000), %dx
	call print_hex
	mov ($0x9000+ 512), %dx
	jmp $

setup32:
	lgdt gdtp
	mov %cr0, %eax
	or $0x1, %eax
	mov %eax, %cr0
	jmp flush

flush:
	movw $(gdt_data_segment - gdt_start), %ax
	movw %ax, %ds
	movw %ax, %ss
	movw %ax, %es
	movw %ax, %fs
	movw %ax, %gs
	movl $0x3000, %esp
	ljmp $0x8, $entry32

.code32
entry32:
	movl $0x10000, %eax
	jmpl *%eax

.code16
print:
    	xorb %bh, %bh
	movb $0x0E, %ah

	lodsb

	/* NULL check */
	cmpb $0, %al
	je 1f

	/* print %al to screen */
	int $0x10
	jmp print

print_hex:
	mov HEX_OUT, %bx
	call print
	ret

disk_error_print:
	mov $DISK_ERROR, %si
	call print

DISK_ERROR:
	.asciz "THERE WAS A DISK ERROR\n"

BOOT_DRIVE:
	.byte 0

HEX_OUT:
	.byte '0x0000', 0

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

idt:
	.word 0
	.long 0

.fill 510-(.-_start), 1, 0
.word 0xaa55
