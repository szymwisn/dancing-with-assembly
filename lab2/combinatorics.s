SYSCALL32 = 0x80
EXIT = 1
STDIN = 0
READ = 3
STDOUT = 1
WRITE = 4
OPEN = 5
CLOSE = 6
ACCESS = 0666
CR_WRONLY_TR = 03101
RDONLY = 0

.data

.text
.globl _start
_start:

	movq $7, %rax				# n
	movq $4, %rbx				# k
	

	pushq %rbx				# k
	pushq %rax				# n
	call binomial_coefficient
	addq $16, %rsp

	exit:
		movl $EXIT, %eax
		int $SYSCALL32
	

	.type factorial, @function
	factorial:
		pushq %rbp
		movq %rsp, %rbp
		subq $8, %rsp

		movl 16(%rbp), %eax		# pierwszy argument funkcji do eax
		movl %eax, -8(%rbp)		# local variable

		cmpl $1, -8(%rbp)		# jesli N = 1 lub 0 to wynik = 1
		jle return_1			# -

		decl %eax			# n - 1
		pushq %rax			# n - 1 jako argument w rekurencyjnym wywolaniu funkcji
		call factorial			# rekurencyjne wywolanie funkcji
		movl 16(%rbp), %ebx		# w 16(%rbp) przechowywany argument funkcji

		imull %ebx, %eax		# w eax 

		jmp end

		return_1:
			movl $1, %eax
			jmp end

		end:
			movq %rbp, %rsp
			popq %rbp
			ret

	.type binomial_coefficient, @function
	binomial_coefficient:
		pushq %rbp
		movq %rsp, %rbp
		subq $16, %rsp

		movl 16(%rbp), %eax
		movl 24(%rbp), %ebx

		movl %eax, -8(%rbp)		# n
		movl %ebx, -16(%rbp)		# k

		movl -8(%rbp), %eax
		pushq %rax
		call factorial
		addq $8, %rsp
		
		pushq %rax			# zachowanie n! na stosie

		movl -16(%rbp), %eax
		pushq %rax
		call factorial
		addq $8, %rsp

		pushq %rax			# zachowanie k! na stosie

		movl -8(%rbp), %eax
		movl -16(%rbp), %ebx

		subl %ebx, %eax			# n - k

		pushq %rax
		call factorial
		addq $8, %rsp		
						# w eax (n-k)!

		popq %rbx			# w ebx k!
		popq %rcx			# w ecx n!
	
		movq %rbp, %rsp
		popq %rbp
		ret

