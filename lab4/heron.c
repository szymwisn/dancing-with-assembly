#include <stdio.h>

float calculateTriangleField(float a, float h);

int main() {
  float a, h, result;

  printf("Enter a: ");
  scanf("%f", &a);
  
  printf("Enter h: ");
  scanf("%f", &h);

  result = calculateTriangleField(a, h);
  printf("S = %f\n", result);

  return 0;
}
