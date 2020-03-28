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

	movq $10, %rax
	pushq %rax
	call fibonacci
	addq $8, %rsp

	movl %ecx, %ebx

	exit:
		movl $EXIT, %eax
		int $SYSCALL32
	

	.type fibonacci, @function
	fibonacci:
		pushq %rbp
		movq %rsp, %rbp
		subq $8, %rsp

		movl 16(%rbp), %eax		# pierwszy argument funkcji do eax
		movl %eax, -8(%rbp)		# local variable

		cmpl $0, -8(%rbp)		# f(0) = 0
		je return_0

		cmpl $1, -8(%rbp)		# f(1) = 1
		je return_1
		
		movl -8(%rbp), %eax
		dec %eax			# n - 1
		movl %eax, %ebx			# zapisanie wartosci n - 1 w ebx
		pushq %rbx			# zachowanie wartosci n - 1
		pushq %rax			# zachowanie wartosci n - 1
		call fibonacci			# rekurencyjne obliczenie f(n - 1)
		addq $8, %rsp			

		popq %rax			# przywrocenie wartosci n - 1
		dec %eax			# n - 2
		pushq %rcx			# zachowanie wartosci f(n - 1)
		pushq %rax			# zachowanie wartosci n - 2
		call fibonacci			# rekurencyjne obliczenie f(n - 2)
		addq $8, %rsp
		
		popq %rax			# przywrocenie wartosci f(n - 1)

		addl %eax, %ecx			# obliczenie f(n - 2) + f(n - 1)
		jmp end	

		return_0:	
			movl $0, %ecx
			jmp end

		return_1:
			movl $1, %ecx
			jmp end

		end:
			movq %rbp, %rsp
			popq %rbp
			ret
