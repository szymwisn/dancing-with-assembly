#include <stdio.h>

void initializeFPU();
int checkBit(int bit);

void setSinglePrecision();
void setDoublePrecision();
void setExtendedPrecision();

void setRoundToNearest();
void setRoundDown();
void setRoundUp();
void setTruncate();

float add(float a, float b);
float substract(float a, float b);
float multiply(float a, float b);
float divide(float a, float b);
float squareRoot(float a);

//void checkExceptions();

void checkExceptions() {
  char *exceptions[] = {
    "Invalid Operation\n",
    "Denormalized Operand\n",
    "Zero Divide\n",
    "Overflow\n",
    "Underflow\n",
    "Precision\n"
  };

  int bits[] = {
    1,
    2,
    4,
    8,
    16,
    32
  };

  for(int i = 0; i < 6; i++) {
    int occurred = checkBit(bits[i]);
    
    if(occurred == 1) {
      printf("Exception occurred: %s", exceptions[i]); 
    }
  }
}

int main() {
  float a, b, result;

  initializeFPU();
  setDoublePrecision();
  setRoundToNearest();

  printf("a = ");
  scanf("%f", &a);

  printf("b = ");
  scanf("%f", &b);

  result = add(a, b);
  printf("\n%f + %f = %f\n", a, b, result);
  checkExceptions();

  result = substract(a, b);
  printf("\n%f - %f = %f\n", a, b, result);
  checkExceptions();

  result = multiply(a, b);
  printf("\n%f * %f = %f\n", a, b, result);
  checkExceptions();

  result = divide(a, b);
  printf("\n%f / %f = %f\n", a, b, result);
  checkExceptions();

  result = squareRoot(a);
  printf("\nsqrt(%f) = %f\n", a, result);
  checkExceptions();

  result = squareRoot(b);
  printf("\nsqrt(%f) = %f\n", b, result);
  checkExceptions();

  return 0;
}
