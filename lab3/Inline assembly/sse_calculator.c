#include <stdio.h>

// struktura będzie przechowywała 128 bitową informację
// 32b * 4 = 128b
typedef struct Data {
    float a, b, c, d;
} Data;

// funkcja dodawania w SIMD
Data addSIMD(Data first, Data second) {
	Data result;

	 __asm__(
    		"MOVUPS %1, %%xmm0\n"         // wpisanie num_a do rejestru xmm0
        	"MOVUPS %2, %%xmm1\n"         // wpisanie num_b do xmm1
        	"ADDPS %%xmm1, %%xmm0\n"       // wykonanie dodawania, wynik w xmm0
        	"MOVUPS %%xmm0, %0\n"          // zapisanie wyniku do zmiennej "result"
        	: "=m"(result)                 // wyjsciowe zmienne
        	: "m"(first), "m"(second)       // wejsciowe zmienne
	);

	return result;
}


// funkcja odejmowania w SIMD
Data subSIMD(Data first, Data second) {
	Data result;

	__asm__(
		"MOVUPS %1, %%xmm0\n"   // wpisanie num_a do rejestru xmm0
		"MOVUPS %2, %%xmm1\n"   // wpisanie num_b do xmm1
		"SUBPS %%xmm1, %%xmm0\n" // wykonanie odejmowania, wynik w xmm0
		"MOVUPS %%xmm0, %0\n"    // zapisanie wyniku do zmiennej "result"
		: "=m"(result)           // wyjsciowe zmienne
		: "m"(first), "m"(second) // wejsciowe zmienne
	);

	return result;
}


// funkcja mnozenia w SIMD
Data mulSIMD(Data first, Data second) {
	Data result;

	__asm__(
        	"MOVUPS %1, %%xmm0 \n"   // wpisanie num_a do rejestru xmm0
                "MOVUPS %2, %%xmm1 \n"   // wpisanie num_b do xmm1
                "MULPS %%xmm1, %%xmm0\n" // wykonanie mnozenia, wynik w xmm0
                "MOVUPS %%xmm0, %0\n"    // zapisanie wyniku do zmiennej "result"
                : "=m"(result)           // wyjsciowe zmienne
                : "m"(first), "m"(second) // wejsciowe zmienne
	);

	return result;
}


// funkcja dzielenia w SIMD
Data divSIMD(Data first, Data second) {
	Data result;

	__asm__(
                "MOVUPS %1, %%xmm0 \n"   // wpisanie num_a do rejestru xmm0
                "MOVUPS %2, %%xmm1 \n"   // wpisanie num_b do xmm1
                "DIVPS %%xmm1, %%xmm0\n" // wykonanie dzielenia, wynik w xmm0
                "MOVUPS %%xmm0, %0\n"    // zapisanie wyniku do zmiennej "result"
                : "=m"(result)           // wyjsciowe zmienne
                : "m"(first), "m"(second) // wejsciowe zmienne
	);

    	return result;
}

int main() {
	Data num_a, num_b;

	num_a.a = 232;
	num_a.b = 11;
	num_a.c = 5;
	num_a.d = 4232;

	num_b.a = 665;
	num_b.b = 10;
	num_b.c = 274;
	num_b.d = 98;

	printf("Data set 1: ");
	printf("%f", num_a.a);
	printf(" %f", num_a.b);
	printf(" %f", num_a.c);
	printf(" %f", num_a.d);

	printf("\nData set 2: ");
	printf("%f", num_b.a);
	printf(" %f", num_b.b);
	printf(" %f", num_b.c);
	printf(" %f", num_b.d);

	Data result = mulSIMD(num_a, num_b);
	printf("\nResults: ");
	printf("%f", result.a);
	printf(" %f", result.b);
	printf(" %f", result.c);
	printf(" %f\n", result.d);
	
	return 0;
}

