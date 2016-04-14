.section .bss
	.lcomm buff, 1
.section .data
ptr:
	.ascii "0000\n" /* 9 байт, 8 байт нулей перезаписываются */
repr1:
	.quad	0x55
repr2:
	.quad	0xA9

.section .text
.global _start
_start:
	mov	$318,	%rax	/*номер системного вызова getrandom()*/
	mov	$buff,	%rdi	/*адрес буфера*/
	mov	$1,	%rsi	/*размер буфера*/
	mov	$0,	%rdx	/*флаги 0 1 2 или 3*/
	syscall

	mov	$1,	%r10	/*непосредственное значение, флаг 1-scissor(ножницы) в регистр*/
	mov	buff,	%r8	/*заносим данные из буфера в регистр*/
	mov	$2,	%r9	/*непосредственное значение, флаг 2-paper(бумага) в регистр*/
	xor	%rsi,	%rsi	/*записываем флаг 0-stone(камень) в регистр */
	cmp	repr1,	%r8	/*сравниваем число с диапазоном значений по первую метку*/
	cmovg	%r10,	%rsi	/*если значение в %r8 больше значения метки то записываем*/
				/*+в регистр %rsi значение из %r10 тоесть флаг 1-scissor*/
	cmp	repr2,	%r8	/*сравниваем число с диапазоном значений по вторую метку*/
	cmovg	%r9,	%rsi	/*меняем значение регистра %rsi*/
	mov	%rsi,	ptr	/*меняем значение первых 8 байт данных строки ptr*/
	
	xor	%rsi,	%rsi	/*обнуляем значение регистра*/

	xor	%rax,	%rax	/*получаем нулевое значение в регистре*/
	inc	%rax		/*увеличиваем значение на 1*/
	xor	%rdi,	%rdi	/*получаем ноль через побитное, исключающее "или"*/
	inc	%rdi		/*икримент 0 дает 1*/
	mov	$ptr,	%rsi	/*заносим адрес в регистр*/
	mov	$9,	%rdx	/*заносим длину данных расположенных по адресу $ptr*/
	syscall			/*вызваем прерывание*/

	mov	$60,	%rax	/*номер системного вызова exit*/
	mov	$0,	%rsi	/*0-без ошибок; коды ошибок /usr/include/asm-generic/errno-base.h*/
	syscall			/*к сожалению не смогла добится вызова getrandom без ошибки*/
