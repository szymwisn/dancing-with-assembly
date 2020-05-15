.data
    control_word: .float 0
    format: .asciz "CW: %f\n"
    invalidOperation: .asciz "Exception: Invalid Operation\n"

.text

.globl initializeFPU
initializeFPU:
  pushl %ebp
  movl %esp, %ebp

  finit
  
  movl %ebp, %esp
  popl %ebp
  ret


.globl checkBit
checkBit:
  pushl %ebp
  movl %esp, %ebp

  fstcw control_word 
  # TODO: Pobrac tego control worda ;<
  movl $32, %eax

  test 8(%ebp), %eax
  jnz exception_found
  movl $0, %eax
  jmp end

  exception_found:
    movl $1, %eax

  end:
    movl %ebp, %esp
    popl %ebp
    ret

 
.globl setSinglePrecision
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
add:
  pushl %ebp
  movl %esp, %ebp

  fld 12(%ebp)
  fld 8(%ebp)
  faddp

  movl %ebp, %esp
  popl %ebp
  ret


.globl substract
substract:
  pushl %ebp
  movl %esp, %ebp

  fld 12(%ebp)
  fld 8(%ebp)
  fsubp

  movl %ebp, %esp
  popl %ebp
  ret


.globl multiply
multiply:
  pushl %ebp
  movl %esp, %ebp

  fld 12(%ebp)
  fld 8(%ebp)
  fmulp

  movl %ebp, %esp
  popl %ebp
  ret


.globl divide
divide:
  pushl %ebp
  movl %esp, %ebp

  fld 12(%ebp)
  fld 8(%ebp)
  fdivp

  movl %ebp, %esp
  popl %ebp
  ret


.globl squareRoot
squareRoot:
  pushl %ebp
  movl %esp, %ebp

  fld 8(%ebp)
  fsqrt

  movl %ebp, %esp
  popl %ebp
  ret

