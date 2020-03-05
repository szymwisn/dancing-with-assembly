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
B_SIZE = 500

.data
BUFFER: .space B_SIZE

.text

.globl _start
_start:

movl $B_SIZE, %edx
movl $BUFFER, %ecx
movl $STDIN, %ebx
movl $READ, %eax
int $SYSCALL32

movl $B_SIZE, %edx
movl $BUFFER, %ecx
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL32

movl $EXIT, %eax
int $SYSCALL32

