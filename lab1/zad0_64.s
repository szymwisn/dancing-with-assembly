EXIT = 60
STDIN = 0
READ = 0
STDOUT = 1
WRITE = 1
OPEN = 2
CLOSE = 6
B_SIZE = 500

.data
BUFFER: .space B_SIZE

.text

.globl _start
_start:

movq $STDIN, %rdi
movq $BUFFER, %rsi
movq $B_SIZE, %rdx
movq $READ, %rax
syscall

movq $STDOUT, %rdi
movq $BUFFER, %rsi
movq $B_SIZE, %rdx
movq $WRITE, %rax
syscall

movq $EXIT, %rax
syscall

