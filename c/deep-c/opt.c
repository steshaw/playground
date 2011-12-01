#include <stdio.h>

int main(void) {
  int a;
  printf("%d\n", a); // Needs "gcc -O -Wall" to see warning about uninitialised 'a'.
}
