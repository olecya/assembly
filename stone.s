.section .bss
	.lcomm buff, 8
.section .data
per:
	.ascii "\n next \n"
point:
	.ascii "00000000\n" /* 9 байт, 8 байт нулей перезаписываются */
stone:
	.ascii "stone\n"
	len_s = . - stone
scissor:
	.ascii "scissor\n"
	len_c = . - scissor
paper:
	.ascii "paper\n"
	len_p = . - paper
flag:
	.quad	0x0000000000000000
repr0:
	.quad	0x0000000000000000
repr1:
	.quad	0x2999999999999999
repr2:
	.quad	0xD555555555555555
.section .text
.global _start
.macro write reg1
#	xor	%rsi,	%rsi
	mov	\reg1,	point
	xor	%rsi,	%rsi
	mov	$point,	%rsi
	xor	%rdi,	%rdi
	xor	%rax,	%rax
	xor	%rdx,	%rdx
	inc	%rax
	inc	%rdi
	mov	$9,	%rdx
	syscall
.endm

.macro ending str, str_len
	xor	%rsi,	%rsi
	xor	%rdi,	%rdi
	mov	$1,	%rax
	mov	$1,	%rdi
	mov	\str,	%rsi
	mov	\str_len,	%rdx
	syscall

	mov	$60,	%rax
	mov	$0,	%rsi
	syscall
.endm
_start:
	mov	$318,	%rax
	mov	$buff,	%rdi
	mov	$8,	%rsi
	mov	$0,	%rdx
	syscall

	mov	buff,	%rdi
	mov	flag,	%rsi
	cmp	%rdi,	repr1
	jg	first
	write	%rsi
	ending	$stone,	$len_s

first:
	inc	%rsi
	mov	%rsi,	flag
	cmp	%rdi,	repr2
	jg	second
	write	%rsi
	ending	$scissor	$len_c

second:
	inc	%rsi
	mov	%rsi,	flag
	write	%rsi
	ending	$paper,	$len_p

