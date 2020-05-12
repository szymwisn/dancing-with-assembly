#include <stdio.h>

unsigned long factorial(unsigned long n);

unsigned long scanNumber() {
	unsigned long number;
	printf("Enter a number: ");
	scanf("%lu", &number);
	return number;
}

void showResult(unsigned long n, unsigned long result) {
	printf("\n%lu! = %lu\n", n, result);
}

unsigned long newFactorial(unsigned long number) {
	return factorial(number);
}

