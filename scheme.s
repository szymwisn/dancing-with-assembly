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

.text

.globl_start
_start:

movl X, %edx
movl Y, %ecx
movl Z, %ebx
movl nr_fun, %eax
int $SYSCALL

movl $EXIT, %eax
movl $0, %ebx
int $SYSCALL

