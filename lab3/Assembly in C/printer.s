.data
	format: .asciz "Entered word: %s\n"

.text
.globl printWord
printWord:
	pushl %ebp
	movl %esp, %ebp
	pushl %ebx
	
	pushl 8(%ebp)
	pushl $format
	call printf
	addl $4, %esp	
	popl %eax	

	popl %ebx
	popl %ebp
	ret

