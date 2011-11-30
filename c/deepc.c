//
// Inspired by http://www.slideshare.net/olvemaudal/deep-c
//

#include <stdio.h>

void foo(void) {
  int a = 41;
  int b;

  b = a = a++; // a finally becomes 42 (with gcc), but "what else could it be"? 41. It's 41 with clang...
               // b is _always_ 41

  printf("a = %d\n", a);
  printf("b = %d\n", b);
}

int main(void) {
  foo();
}
