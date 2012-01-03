#include <stdio.h>

int main(void) {
  static int i = 0;
  ++i;
  printf("%d\n", i);
  main();
  return 0;
}
