#include <stdio.h>

unsigned long scanNumber() {
	unsigned long number;
	printf("Enter a number: ");
	scanf("%lu", &number);
	return number;
}

unsigned long factorial(unsigned long n) {
	if (n == 0 || n == 1) {
		return 1;
	} else {
		return n * factorial(n - 1);	
	}
}

void showResult(unsigned long n, unsigned long result) {
	printf("%lu! = %lu\n", n, result);
}

