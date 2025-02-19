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

	movq $MAX_VAL, %rbx
	pushq %rbx
	call initialize
	addq $8, %rsp

	movq $MAX_VAL, %rbx
	pushq %rbx
	call find_prime_numbers
	addq $8, %rsp

	movq $MAX_VAL, %rbx
	pushq %rbx
	call collect_prime_numbers
	addq $8, %rsp	

	exit:
		movl $EXIT, %eax
		int $SYSCALL32
	
	# CEL: wypelnienie tablicy wartosciami
	# INPUT: Pierwszy argument - wielkosc tablicy
	# OUTPUT: brak
	# ZMIENNE:
	#	%ebx - wielkosc tablicy 
	# 	%ecx - licznik
	.type initialize, @function
	initialize:
		pushq %rbp				# zapisanie starego base pointera
		movq %rsp, %rbp				# ustawienie stack pointera base pointerem
		subq $8, %rsp				# miejsce dla tzw. local storage
	
		movl 16(%rbp), %ebx			# pierwszy argument funkcji
		movl %ebx, -8(%rbp)			# wpisanie argumentu do zmiennej lokalnej
	
		movl $0, %ecx
	
		# wypelnienie tablicy liczbami
		fill_array:
			movl %ecx, NUM_ARRAY(,%ecx,4)	# wpisanie wartosci do tablicy
			inc %ecx			# inkrementacja licznika
			cmpl -8(%rbp), %ecx		# sprawdzenie czy licznik osiagnal wartosc max
			jl fill_array 			# jesli nie - kontynuuj wypelnianie tablicy

		movl %ebx, %ecx				# wypelnienie ostatniej cyfry
		movl %ecx, NUM_ARRAY(,%ecx,4);		# -
		
		movq %rbp, %rsp				# przywrocenie stack pointera
		popq %rbp				# przywrocenie base pointera
		ret
		

	.type find_prime_numbers, @function
	find_prime_numbers:
		pushq %rbp
		movq %rsp, %rbp
		subq $8, %rsp		
	
		movl 16(%rbp), %ebx
		movl %ebx, -8(%rbp)
		
		movl $1, %ecx

		array_iteration:	
			inc %ecx			# inkrementuje licznik	
			mov %ecx, %edi			# licznik wewnetrzny w edi
			cmpl $-1, NUM_ARRAY(,%ecx,4)	# sprawdzenie czy liczba juz wykluczona
			jne should_cross_out		# jesli nie wukluczona - sprawdzam ja
			cmpl -8(%rbp), %ecx		# sprawdzam czy sprawdzono cala tablice
			jl array_iteration		# jesli nie - przechodze do kolejnej iteracji
			movl $1, %ecx			# ustawienie licznika dla collect_prime_numbers
			jmp collect_prime_numbers	# jesli tak - przechodze do zbierania liczb

		should_cross_out:
			inc %edi			# nie musze sprawdzac liczby samej z soba, inkrementuje licznik
			cmpl $MAX_VAL + 1, %edi		# jesli cyfra poza skala -
			je array_iteration		# koncze iterowac po wewnetrznej petli
			cmpl $-1, NUM_ARRAY(,%edi,4)	# sprawdzam czy liczba juz wykluczona
			je should_cross_out		# jesli tak - przechodze do kolejnej
			movl NUM_ARRAY(,%edi,4), %eax	# przechowanie wartosci wewnetrznej petli w eax
			movl NUM_ARRAY(,%ecx,4), %ebx	# przechowanie wartosci zewnetrznej petli w ebx
			movl $0, %edx			# wyzerowanie reszty
			divl %ebx			# podziel wartosc z petli wewnetrznej przez wartosc w petli zewnetrznej
			cmpl $0, %edx			# jesli reszta wynosi 0 to znaczy ze liczba z petli wewnetrznej jest
							# wielokrotnoscia liczby z petli zewnetrznej - wykreslam ja
			je cross_out			# jesli liczba w petli wewnetrznej jest wielokrotnoscia liczby z petli
							# zewnetrznej wykreslam ja		
			cmpl -8(%rbp), %edi		# sprawdzam czy licznik petli wewn. skonczony	
			je array_iteration		# jesli tak - wszystkie liczby w petli wewn. sprawdzone
			jmp should_cross_out		# przejscie do kolejnej liczby w petli wewnetrznej	

		cross_out:
			movl $-1, NUM_ARRAY(,%edi,4)	# wykreslenie liczby
			cmpl -8(%rbp), %edi		# sprawdzenie czy ostatnia liczba
			je array_iteration		# jesli ostatnia - wszystkie liczby w petli wewn. sprawdzone
			jmp should_cross_out		# kolejna iteracja petli wewnetrznej

		movq %rbp, %rsp
		popq %rbp
		ret	

	.type collect_prime_numbers, @function
	collect_prime_numbers:
		pushq %rbp
		movq %rsp, %rbp	
		subq $8, %rsp	

		movl 16(%rbp), %ebx
		movl %ebx, -8(%rbp)
		
		inc %ecx			# inkrementacja licznika
		cmpl $MAX_VAL + 1, %ecx		# jesli cyfra poza skala -
		je exit				# mozna skonczyc iterowac
		cmpl $-1, NUM_ARRAY(,%ecx,4)	# sprawdzenie czy wartosc wykluczona, jesli tak -
		je collect_prime_numbers	# mozna przejsc do kolejnej wartosci
		push NUM_ARRAY(,%ecx,4)		# wrzucenie wartosci na stos
		jmp collect_prime_numbers	# sprawdzenie kolejnej cyfry		
		
		movq %rbp, %rsp
		popq %rbp
		ret

