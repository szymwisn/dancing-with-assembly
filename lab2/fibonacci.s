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

	movq $4, %rax
	pushq %rax
	call fibonacci
	addq $8, %rsp

	movl %eax, %ebx

	exit:
		movl $EXIT, %eax
		int $SYSCALL32
	

	.type fibonacci, @function
	fibonacci:
		pushq %rbp
		movq %rsp, %rbp
		subq $8, %rsp

		movl 16(%rbp), %eax
		movl %eax, -8(%rbp)

		cmpl $0, -8(%rbp)
		je return_0

		cmpl $1, -8(%rbp)
		je return_1
		
		movl -8(%rbp), %eax
		dec %eax
		pushq %rax
		call fibonacci
		addq $8, %rsp		

		pushq %rax

		movl -8(%rbp), %ebx
		dec %ebx
		pushq %rbx
		call fibonacci
		addq $8, %rsp
		
		movl %eax, %ebx

		popq %rax
		addl %ebx, %eax	
		jmp end	

		return_0:	
			movl $0, %eax
			jmp end

		return_1:
			movl $1, %eax
			jmp end

		end:
			movq %rbp, %rsp
			popq %rbp
			ret
