#include <stdio.h>

int main(void) {
  {
    int a = 41; a++; printf("%d\n", a); // 42
  }
  {
    int a = 41; a++ & printf("%d\n", a); // undefined (gcc 41, clang 42)
  }
  {
    int a = 41; a++ && printf("%d\n", a); // 42
  }
  {
    int a = 41; if (a++ < 42) printf("%d\n", a); // 42
  }
  {
    int a = 41; a = a ++; printf("%d\n", a); // undefined (gcc 42, clang 41)
  }
}
