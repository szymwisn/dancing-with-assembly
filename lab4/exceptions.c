#include <stdio.h>

void initializeFPU();

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

int main() {
  float a, b, result;

  initializeFPU();
  setExtendedPrecision();
  setTruncate();

  printf("\na = ");
  scanf("%f", &a);

  printf("b = ");
  scanf("%f", &b);

  printf("\n=== Addition ===");
  result = add(a, b);
  printf("\n%f + %f = %f\n", a, b, result);

  printf("\n=== Substraction ===");
  result = substract(a, b);
  printf("\n%f - %f = %f\n", a, b, result);

  printf("\n=== Multiplication ===");
  result = multiply(a, b);
  printf("\n%f * %f = %f\n", a, b, result);

  printf("\n=== Division  ===");
  result = divide(a, b);
  printf("\n%f / %f = %f\n", a, b, result);

  printf("\n=== Square root a ===");
  result = squareRoot(a);
  printf("\nsqrt(%f) = %f\n", a, result);

  printf("\n=== Square root b ===");
  result = squareRoot(b);
  printf("\nsqrt(%f) = %f\n", b, result);

  return 0;
}
