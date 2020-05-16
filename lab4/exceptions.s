.data
    control_word: .int 0
    format: .asciz "\nCW: %d\n"
    invalidOperation: .asciz "\nException: Invalid operation"
    denormalizedOperand: .asciz "\nException: Denormalized operand"
    zeroDivide: .asciz "\nException: Division by zero"
    overflow: .asciz "\nException: Overflow"
    underflow: .asciz "\nException: Underflow"
    Precision: .asciz "\nException: Precision lost"

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

  fstcw control_word                     # pobierz obecne CW do control_word
  movl $control_word, %ecx               # zapisanie CW do rejestru ecx
    
  andl $0xFCFF, %ecx      
  orl  $0x0000, %ecx # single

  movl %ecx, control_word               # zaladowanie zawartosci ecx do
                                        # control_word
  fldcw control_word                    # zaladowanie zmodyfikowanego CW

  movl %ebp, %esp
  popl %ebp
  ret


.globl setDoublePrecision
.type setDoublePrecision, @function
setDoublePrecision:
  pushl %ebp
  movl %esp, %ebp

  fstcw control_word                    # pobierz obecne CW do control_word
  movl $control_word, %ecx               # zapisanie CW do rejestru ecx
    
  andl $0xFCFF, %ecx      
  orl  $0x0200, %ecx                    # double

  movl %ecx, control_word               # zaladowanie zawartosci ecx do
                                        # control_word
  fldcw control_word                    # zaladowanie zmodyfikowanego CW

  movl %ebp, %esp
  popl %ebp


.globl setExtendedPrecision
.type setExtendedPrecision, @function
setExtendedPrecision:
  pushl %ebp
  movl %esp, %ebp

  fstcw control_word                    # pobierz obecne CW do control_word
  movl $control_word, %ecx               # zapisanie CW do rejestru ecx
    
  andl $0xFCFF, %ecx      
  orl  $0x0300, %ecx                    # double extended

  movl %ecx, control_word               # zaladowanie zawartosci ecx do
                                        # control_word
  fldcw control_word                    # zaladowanie zmodyfikowanego CW

  movl %ebp, %esp
  popl %ebp


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
 
  movl %ebp, %esp
  popl %ebp
  ret


.globl add
.type add, @function
add:
  pushl %ebp
  movl %esp, %ebp

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

  fstcw control_word 
  movl control_word, %eax

  pushl %eax
  pushl $format
  call printf
  addl $8, %esp

  invalid_operation: 
    test $1, %eax
    jz denormalized_operand
    pushl $invalidOperation
    call printf
    addl $4, %esp
    
  denormalized_operand:
    test $2, %eax
    jz zero_divide
    pushl $denormalizedOperand
    call printf
    addl $4, %esp

  zero_divide:
    test $3, %eax
    jz overflow_
    pushl $zero_divide
    call printf
    addl $4, %esp

  overflow_:
    test $4, %eax
    jz underflow_
    pushl $overflow
    call printf  
    addl $4, %esp  

  underflow_:
    test $5, %eax
    jz precision
    pushl $underflow
    call printf
    addl $4, %esp

  precision:
    test $6, %eax
    jz end
    pushl $precision
    call printf
    addl $4, %esp

  end:
    movl %ebp, %esp
    popl %ebp
    ret

