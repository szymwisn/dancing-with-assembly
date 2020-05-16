.data
    control_word: .int 0
    status_word: .int 0
    
    cw_format: .asciz "New Control Word: %d (dec)\n"
    sw_format: .asciz "\nStatus Word: %d (dec)"
    invalid: .asciz "\nException: Invalid operation"
    denormalized: .asciz "\nException: Denormalized operand"
    zero: .asciz "\nException: Division by zero"
    overflow: .asciz "\nException: Overflow"
    underflow: .asciz "\nException: Underflow"
    precision: .asciz "\nException: Precision lost"

.text

.globl initializeFPU
.type initializeFpu, @function
initializeFPU:
  pushl %ebp
  movl %esp, %ebp

  finit
  
  movl %ebp, %esp
  popl %ebp
  ret

 
.globl setSinglePrecision
.type setSinglePrecision, @function
setSinglePrecision:
  pushl %ebp
  movl %esp, %ebp

  fstcw control_word                    # pobierz obecne CW do control_word
  movl control_word, %ecx               # zapisanie CW do rejestru ecx
    
  andl $0xFCFF, %ecx      
  orl  $0x0000, %ecx                    # single

  movl %ecx, control_word               # zaladowanie zawartosci ecx do
                                        # control_word
  fldcw control_word                    # zaladowanie zmodyfikowanego CW

  call printCW

  movl %ebp, %esp
  popl %ebp
  ret


.globl setDoublePrecision
.type setDoublePrecision, @function
setDoublePrecision:
  pushl %ebp
  movl %esp, %ebp

  fstcw control_word                    # pobierz obecne CW do control_word
  movl control_word, %ecx               # zapisanie CW do rejestru ecx
    
  andl $0xFCFF, %ecx      
  orl  $0x0200, %ecx                    # double

  movl %ecx, control_word               # zaladowanie zawartosci ecx do
                                        # control_word
  fldcw control_word                    # zaladowanie zmodyfikowanego CW

  call printCW

  movl %ebp, %esp
  popl %ebp
  ret

.globl setExtendedPrecision
.type setExtendedPrecision, @function
setExtendedPrecision:
  pushl %ebp
  movl %esp, %ebp

  fstcw control_word                    # pobierz obecne CW do control_word
  movl control_word, %ecx               # zapisanie CW do rejestru ecx
    
  andl $0xFCFF, %ecx      
  orl  $0x0300, %ecx                    # double extended

  movl %ecx, control_word               # zaladowanie zawartosci ecx do
                                        # control_word
  fldcw control_word                    # zaladowanie zmodyfikowanego CW

  call printCW

  movl %ebp, %esp
  popl %ebp
  ret

.globl setRoundToNearest
.type setRoundToNearest, @function
setRoundToNearest:
  pushl %ebp
  movl %esp, %ebp

  fstcw control_word                    # pobierz obecne CW do control_word
  movl $control_word, %ecx  

  andl $0xF3FF, %ecx
  orl  $0x0000, %ecx                    # nearest

  movl %ecx, control_word               # zaladowanie zawartosci ecx do
                                        # control_word
  fldcw control_word                    # zaladowanie zmodyfikowanego CW
 
  call printCW
  
  movl %ebp, %esp
  popl %ebp
  ret


.globl setRoundDown
.type setRoundDown, @function
setRoundDown:
  pushl %ebp
  movl %esp, %ebp

  fstcw control_word                    # pobierz obecne CW do control_word
  movl $control_word, %ecx  

  andl $0xF3FF, %ecx
  orl  $0x0400, %ecx                    # down

  movl %ecx, control_word               # zaladowanie zawartosci ecx do
                                        # control_word
  fldcw control_word                    # zaladowanie zmodyfikowanego CW
 
  call printCW
 
   movl %ebp, %esp
  popl %ebp
  ret


.globl setRoundUp
.type setRoundUp, @function
setRoundUp:
  pushl %ebp
  movl %esp, %ebp

  fstcw control_word                    # pobierz obecne CW do control_word
  movl $control_word, %ecx  

  andl $0xF3FF, %ecx
  orl  $0x0800, %ecx                    # up

  movl %ecx, control_word               # zaladowanie zawartosci ecx do
                                        # control_word
  fldcw control_word                    # zaladowanie zmodyfikowanego CW

  call printCW
 
  movl %ebp, %esp
  popl %ebp
  ret


.globl setTruncate
.type setTruncate, @function
setTruncate:
  pushl %ebp
  movl %esp, %ebp

  fstcw control_word                    # pobierz obecne CW do control_word
  movl $control_word, %ecx  

  andl $0xF3FF, %ecx
  orl  $0x0C00, %ecx                    # truncate

  movl %ecx, control_word               # zaladowanie zawartosci ecx do
                                        # control_word
  fldcw control_word                    # zaladowanie zmodyfikowanego CW

  call printCW
 
  movl %ebp, %esp
  popl %ebp
  ret


.globl add
.type add, @function
add:
  pushl %ebp
  movl %esp, %ebp

  fclex

  fld 12(%ebp)
  fld 8(%ebp)
  faddp

  call checkForExceptions

  movl %ebp, %esp
  popl %ebp
  ret


.globl substract
.type substract, @function
substract:
  pushl %ebp
  movl %esp, %ebp

  fclex

  fld 12(%ebp)
  fld 8(%ebp)
  fsubp

  call checkForExceptions

  movl %ebp, %esp
  popl %ebp
  ret


.globl multiply
.type multiply, @function
multiply:
  pushl %ebp
  movl %esp, %ebp

  fclex

  fld 12(%ebp)
  fld 8(%ebp)
  fmulp

  call checkForExceptions

  movl %ebp, %esp
  popl %ebp
  ret


.globl divide
.type divide, @function
divide:
  pushl %ebp
  movl %esp, %ebp

  fclex

  fld 12(%ebp)
  fld 8(%ebp)
  fdivp

  call checkForExceptions

  movl %ebp, %esp
  popl %ebp
  ret


.globl squareRoot
.type squareRoot, @function
squareRoot:
  pushl %ebp
  movl %esp, %ebp

  fclex

  fld 8(%ebp)
  fsqrt

  call checkForExceptions

  movl %ebp, %esp
  popl %ebp
  ret


.type checkForExceptions, @function
checkForExceptions:
  pushl %ebp
  movl %esp, %ebp

  fstsw status_word
  movl status_word, %ecx

  call printSW

  invalid_operation_ex: 
    movl %ecx, %eax
    andl $1, %eax
    cmpl $1, %eax
    jz denormalized_ex
    pushl $invalid
    call printf
    addl $4, %esp
 
  denormalized_ex:
    movl %ecx, %eax
    andl $2, %eax
    cmpl $2, %eax
    jz zero_ex
    pushl $denormalized
    call printf
    addl $4, %esp

  zero_ex:
    movl %ecx, %eax
    andl $3, %eax
    cmpl $3, %eax
    jz overflow_ex
    pushl $zero
    call printf
    addl $4, %esp

  overflow_ex:
    movl %ecx, %eax
    andl $4, %eax
    cmpl $4, %eax
    jz underflow_ex
    pushl $overflow
    call printf  
    addl $4, %esp  

  underflow_ex:
    movl %ecx, %eax
    andl $5, %eax
    cmpl $5, %eax
    jz precision_ex
    pushl $underflow
    call printf
    addl $4, %esp

  precision_ex:
    movl %ecx, %eax
    andl $6, %eax
    cmpl $6, %eax
    jnz end
    pushl $precision
    call printf
    addl $4, %esp

  end:
    movl %ebp, %esp
    popl %ebp
    ret


.type printSW, @function
printSW:
  pushl %ebp
  movl %esp, %ebp
  
  fstsw status_word
  movl status_word, %eax

  pushl %eax
  pushl $sw_format
  call printf
  addl $8, %esp

  movl %ebp, %esp
  popl %ebp
  ret


.type printCW, @function
printCW:
  pushl %ebp
  movl %esp, %ebp

  fstcw control_word
  movl control_word, %eax
  
  pushl %eax
  pushl $cw_format
  call printf
  addl $8, %esp

  movl %ebp, %esp
  popl %ebp
  ret
