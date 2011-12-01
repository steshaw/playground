#include <stdio.h>

struct X { int a; char b; int n; };
struct X1 { int a; char b; int n; char c; };
struct X2 { int a; char b; char c; int n; };
struct X3 { int a; char b; int n; char *d; };

int main(void) {
  printf("sizeof(int) = %zu\n", sizeof(int));
  printf("sizeof(long) = %zu\n", sizeof(long));
  printf("sizeof(void*) = %zu\n", sizeof(void*));
  printf("sizeof(char) = %zu\n", sizeof(char));
  printf("sizeof(struct X) = %zu\n", sizeof(struct X));
  printf("sizeof(struct X1) = %zu\n", sizeof(struct X1));
  printf("sizeof(struct X2) = %zu\n", sizeof(struct X2));
  printf("sizeof(struct X3) = %zu\n", sizeof(struct X3));
}
