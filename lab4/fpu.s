EXIT = 1
SYSCALL32 = 0x80

.data
    zero: .float 0
    one: .float 1
    ten: .float 10
    minus_five: .float -5

    medium_float: .float 5.323165e24
    very_small_float: .float 1.175494e-38
    very_big_float: .float 3.402823e38

    medium_double: .double 7.2250738585072e208
    very_small_double: .double 2.2250738585072e-308
    very_big_double: .double 1.79769313486231e308

    control_word: .int 0
    status_word: .int 0

    format: .asciz "\n%d\n"

.text

.globl _start
_start:
  
  # ----
  # inicjalizacja FPU, przywraca FPU do domyślnego stanu, niejawnie wywołuje FWAIT - synchronizacja z CPU
  #
  finit
  fclex 

  # ----
  # zaladownie rejetru CW do rejestru ecx
  #
  fstcw control_word                    # pobierz obecne CW do control_word
  movl control_word, %ecx               # zapisanie CW do rejestru ecx
    
  # ----
  # ustawienie bitów PC - Precision Control - REAL4/REAL8/REAL10
  # za PC odpowiadaja bity 8 i 9 - tylko na nich operuje, reszte
  # pozostawiam bez zmian
  # 00 - REAL4 - single
  # 10 - REAL8 - double
  # 11 - REAL10 - extended double 
  #
  andl $0xFCFF, %ecx      
  #orl  $0x0000, %ecx # single
  orl  $0x0200, %ecx # double
  #orl  $0x0300, %ecx # double extended

  # ----
  # ustawienie bitów RC - Round Control - REAL4/REAL8/REAL10
  # za RC odpowiadaja bity 10 i 11 - tylko na nich operuje, reszte
  # pozostawiam bez zmian
  # 00 - round to nearest
  # 01 - round down (-> -inf)
  # 10 - round up (-> +inf)
  # 11 - truncate (-> 0)
  #
  andl $0xF3FF, %ecx
  #orl  $0x0000, %ecx # nearest
  #orl  $0x0400, %ecx # down
  orl  $0x0800, %ecx # up
  #orl  $0x0C00, %ecx # truncate

  # ----
  # zaladowanie ustawionego w rejestrze control word
  #
  movl %ecx, control_word             # zaladowanie zawartosci ecx do
                                      # control_word
  fldcw control_word                  # zaladowanie zmodyfikowanego CW
 

  jmp zero_divide

  # ----
  # Invalid operation (#I)
  # pierwiastek z liczby ujemnej
  #
  invalid_operation:
    fclex                         # czysci wyjatki
    fld minus_five
    fsqrt    
    jmp end

  # ----
  # Denormalized operand (#D)
  #
  denormalized_operand:
    #

  # ----
  # Zero divide (#Z)
  # dzielenie przez 0
  #
  zero_divide:
    fclex
    fldz
    fld one
    fdivp
    jmp end

  # ----
  # Numeric overflow (#O)
  #
  overflow:
    fclex                         # czysci wyjatki
    fld very_big_float
    fld medium_float
    fmulp
    jmp end

  # ----
  # Numeric underflow (#U)
  #
  underflow:
    fclex                         # czysci wyjatki
    fld very_big_float
    fld very_small_float
    fdivp
    jmp end

  # ----
  # Inexact result (precision) (#P)
  # utrata precyzji, np. poprzez podzielenie 1 przez 10
  precision:
    fclex                         # czysci wyjatki
    fld ten
    fld one
    fdivp
    jmp end

  end: 
    movl $EXIT, %eax
    int $SYSCALL32

