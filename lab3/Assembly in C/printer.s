.data
	format: .asciz "Entered word: %s\n"

.text
.globl printWord
printWord:
	pushl %ebp
	movl %esp, %ebp
	
	pushl 8(%ebp)
	pushl $format
	call printf
	addl $8, %esp	

	movl %ebp, %esp
	popl %ebp
	ret

