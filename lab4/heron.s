.data
  two: .float 2

.text

.globl calculateTriangleField
calculateTriangleField:
pushl %ebp
movl %esp, %ebp

finit

flds two
flds 8(%ebp)
fdivp 
flds 12(%ebp)
fmulp

movl %ebp, %esp
popl %ebp
ret
