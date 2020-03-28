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

MAX_VAL = 6
BUFF_SIZE = 1000

.bss
	.lcomm BUFFER, BUFF_SIZE
	.lcomm NUM_ARRAY, BUFF_SIZE

.text
.globl _start
_start:
	movl $2, %ecx				# 0 i 1 nie sa liczbami pierwszymi
	
	# wypelnienie tablicy liczbami
	fill_array:
		movl %ecx, NUM_ARRAY(,%ecx,4)	# wpisanie wartosci do tablicy
		inc %ecx			# inkrementacja licznika
		cmpl $MAX_VAL, %ecx		# sprawdzenie czy licznik osiagnal wartosc max
		jl fill_array 			# jesli nie - kontynuuj wypelnianie tablicy

	movl $MAX_VAL, %ecx			# wypelnienie ostatniej cyfry
	movl %ecx, NUM_ARRAY(,%ecx,4);		# -

	movl $1, %ecx

	array_iteration:	
		inc %ecx			# inkrementuje licznik	
		mov %ecx, %edi			# licznik wewnetrzny w edi
		cmpl $-1, NUM_ARRAY(,%ecx,4)	# sprawdzenie czy liczba juz wykluczona
		jne should_cross_out		# jesli nie wukluczona - sprawdzam ja
		cmpl $MAX_VAL, %ecx		# sprawdzam czy sprawdzono cala tablice
		jl array_iteration		# jesli nie - przechodze do kolejnej iteracji
		jmp exit			# jesli tak - przechodze do zbierania liczb

	should_cross_out:
		inc %edi			# nie musze sprawdzac liczby samej z soba, inkrementuje licznik
		cmpl $MAX_VAL + 1, %edi
		je array_iteration
		cmpl $-1, NUM_ARRAY(,%edi,4)	# sprawdzam czy liczba juz wykluczona
		je should_cross_out		# jesli tak - przechodze do kolejnej
		movl NUM_ARRAY(,%edi,4), %eax	# przechowanie wartosci wewnetrznej petli w eax
		divl NUM_ARRAY(,%ecx,4)		# podziel wartosc z petli wewnetrznej przez wartosc w petli zewnetrznej
		cmpl $0, %edx			# jesli reszta wynosi 0 to znaczy ze liczba z petli wewnetrznej jest
						# wielokrotnoscia liczby z petli zewnetrznej - wykreslam ja
		je cross_out			# jesli liczba w petli wewnetrznej jest wielokrotnoscia liczby z petli
						# zewnetrznej wykreslam ja		
		cmpl $MAX_VAL, %edi		# sprawdzam czy licznik petli wewn. skonczony	
		je array_iteration		# jesli tak - wszystkie liczby w petli wewn. sprawdzone
		jmp should_cross_out		# przejscie do kolejnej liczby w petli wewnetrznej	

	cross_out:
		movl $-1, NUM_ARRAY(,%edi,4)	# wykreslenie liczby
		cmpl $MAX_VAL, %edi
		je array_iteration
		jmp should_cross_out		# kolejna iteracja petli wewnetrznej

	exit:
		movl $EXIT, %eax
		int $SYSCALL32

