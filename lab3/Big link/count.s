.data
	format: .asciz "\n%lu"

.text
.globl factorial
factorial:
	pushl %ebp
	movl %esp, %ebp
	push %ebx
	
	cmpl $1, 8(%ebp)		# jesli N = 1 lub 0 to wynik = 1
	jle return_1			# -

	movl 8(%ebp), %edx
	decl %edx			# n - 1
	pushl %edx			# n - 1 jako argument w rekurencyjnym wywolaniu funkcji
	call factorial			# rekurencyjne wywolanie funkcji
	pop %edx			# przywrocenie n-1
	addl $1, %edx

	imull %edx, %eax		# (n-1) * n 

	jmp print

	return_1:
		movl $1, %eax


	print:
		pushl %eax
		pushl $format
		call printf
		addl $4, %esp
		popl %eax

	end:
		popl %ebx
		popl %ebp
		ret

