#include <stdio.h>

unsigned long printWord(char *text);

int main() {
	char word[256];
	printf("Please enter your word: ");
	scanf("%s", &word);
	printWord(word);
	
	return 0;
}

