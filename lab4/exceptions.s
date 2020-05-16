.data
    control_word: .int 0
    status_word: .int 0
    
    cw_format: .asciz "> Control Word: %d (dec)\n"
    sw_format: .asciz "\n> Status Word: %d (dec)"
    invalid: .asciz "\n!!! Exception: Invalid operation"
    denormalized: .asciz "\n!!! Exception: Denormalized operand"
    zero: .asciz "\n!!! Exception: Division by zero"
    overflow: .asciz "\n!!! Exception: Overflow"
    underflow: .asciz "\n!!! Exception: Underflow"
    precision: .asciz "\n!!! Exception: Precision lost"

.text


.globl initializeFPU
.type initializeFpu, @function
initializeFPU:
  pushl %ebp
  movl %esp, %ebp

  finit
  
  call printCW
  
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
  movl control_word, %ecx  

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
  movl control_word, %ecx  

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
  movl control_word, %ecx  

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
  movl control_word, %ecx               # zapisanie CW do rejestru ecx
    
  andl $0xF3FF, %ecx      
  orl  $0x0C00, %ecx                    # double

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

  call printSW
  
  fstsw status_word

  invalid_operation_ex: 
    movl status_word, %eax
    andl $1, %eax
    cmpl $1, %eax
    jne denormalized_ex
    pushl $invalid
    call printf
    addl $4, %esp
 
  denormalized_ex:
    movl status_word, %eax
    andl $2, %eax
    cmpl $2, %eax
    jne zero_ex
    pushl $denormalized
    call printf
    addl $4, %esp

  zero_ex:
    movl status_word, %eax
    andl $4, %eax
    cmpl $4, %eax
    jne overflow_ex
    pushl $zero
    call printf
    addl $4, %esp

  overflow_ex:
    movl status_word, %eax
    andl $8, %eax
    cmpl $8, %eax
    jne underflow_ex
    pushl $overflow
    call printf  
    addl $4, %esp  

  underflow_ex:
    movl status_word, %eax
    andl $16, %eax
    cmpl $16, %eax
    jne precision_ex
    pushl $underflow
    call printf
    addl $4, %esp

  precision_ex:
    movl status_word, %eax
    andl $32, %eax
    cmpl $32, %eax
    jne end
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
