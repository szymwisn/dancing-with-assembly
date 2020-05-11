#include <stdio.h>

unsigned long factorial(unsigned long n);

int main() {
	unsigned long number, result;
	
	scanf("%lu", &number);
	printf("\nRecursive search for factorial of %lu...", number);
	result = factorial(number);
	printf(" <- FOUND");
	printf("\n\n%lu! = %lu\n", number, result);

	return 0;
}

