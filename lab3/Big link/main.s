EXIT = 1
SYSCALL32 = 0x80

.data

.text
.globl main
main:
	call scanNumber
	movl %eax, %ebx

	pushl %ebx
	call newFactorial

	pushl %eax
	pushl %ebx	
	call showResult

	movl $EXIT, %eax
	int $SYSCALL32


