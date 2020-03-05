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
KEY: .long 2

.text
.globl _start
_start:

# wczytanie ciagu znakow z klawiatury
read:
movl $B_SIZE, %edx
movl $BUFFER, %ecx
movl $STDIN, %ebx
movl $READ, %eax # eax przechowuje dlugosc wczytanego ciagu znakow
int $SYSCALL32

# usuniecie znaku nowej linii
decl %eax

# wyzerowanie licznika
movl $0, %ecx

# zamiana malych na duze
convert:
movb BUFFER(, %ecx, 1), %bh
movb %bh, %dh
cmpb $' ', %dh
jne continue

# pomijam spacje 
inc %ecx
jmp convert

continue:
movb $0x20, %bl
not %bl
and %bh, %bl

caesar:
addb $3, %bl
cmpb $'Z', %bl
jle continue2
subb $26, %bl

continue2:
movb %bl, BUFFER(, %ecx, 1)
incl %ecx
cmpl %eax, %ecx  
jl convert

# dodanie znaku nowej linii na koncu
movb $'\n', BUFFER(, %ecx, 1)

# wypisanie ciagu znakow na ekranie
write:
movl $B_SIZE, %edx
movl $BUFFER, %ecx
movl $STDOUT, %ebx
movl $WRITE, %eax
int $SYSCALL32

exit:
movl $EXIT, %eax
int $SYSCALL32

