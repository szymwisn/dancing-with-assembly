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

MAX_VAL = 100
BUFF_SIZE = 1000

.bss
	.lcomm BUFFER, BUFF_SIZE
	.lcomm NUM_ARRAY, BUFF_SIZE

.text
.globl _start
_start:
	movl $0, %ecx				# wyzerowanie licznika
	
	# wypelnienie tablicy liczbami
	fill_array:
		movl %ecx, NUM_ARRAY(,%ecx,4)	# wpisanie wartosci do tablicy
		inc %ecx			# inkrementacja licznika
		cmpl $MAX_VAL, %ecx		# sprawdzenie czy licznik osiagnal wartosc max
		jl fill_array 			# jesli nie - kontynuuj wypelnianie tablicy

	# iteruj po kolejnych cyfrach
		# znajdz cyfry, ktore dziela sie przez zadana liczbe i sa wieksze/rowne od jej kwadratu
		# ustaw te cyfry na wartosc -1
	# przejdz do kolejnej cyfry
	# push cyfry, ktore nie sa ustawione na -1 na stos
	
	movl $0, %ecx

	array_iteration:
		cmpl $-1, NUM_ARRAY(,%ecx,4)	# sprawdzenie czy liczba juz wykluczona
		jne cross_out
		inc %ecx
		cmpl $MAX_VAL, %ecx
		jl array_iteration
		jmp collect_prime_numbers

	cross_out:
		mov %ecx, %edi			# wskaznik wewnetrzny w edi
		inc %edi			# nie musze sprawdzac liczby samej z soba, inkrementuje licznik
		cmpl $-1, NUM_ARRAY(,%edi,4)
		je cross_out			# liczba byla juz wykluczona
		cmpl $MAX_VAL, %edi		
		je array_iteration		# wszystkie liczby w petli wewn. sprawdzone
		movl NUM_ARRAY(,%edi,4), %eax	# przechowanie wartosci wewnetrznej petli w eax
		divl NUM_ARRAY(,%ecx,4)		# podziel wartosc z petli wewnetrznej przez wartosc w petli zewnetrznej
		cmpl $0, %edx
		jne cross_out			# jesli liczba w petli wewnetrznej nie jest wielokrotnoscia liczby z petli
						# zewnetrznej nie wykreslam jej
		movl $-1, NUM_ARAY(,%edi,4)	# wykreslenie liczby
		jmp cross_out

	movl $0, %ecx
	
	collect_prime_numbers:
		inc %ecx
		cmpl $-1, NUM_ARRAY(,%ecx,4)
		je collect_prime_numbers
		inc $ecx
		cmpl $
				
				
	

	# wypisanie ciagu znakow na ekranie
	#write:
	#	movl $BUFF_SIZE, %edx
	#	movl $BUFFER, %ecx
	#	movl $STDOUT, %ebx
	#	movl $WRITE, %eax
	#	int $SYSCALL32

	exit:
		movl $EXIT, %eax
		int $SYSCALL32

