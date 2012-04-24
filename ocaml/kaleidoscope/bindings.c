#include <stdio.h>

// putchard - putchar that takes a double and returns 0.
extern double putchard(double x) {
  putchar((char)x);
  return 0;
}

// printd - printf that takes a double, print it as "%f\n", returning 0.
extern double printd(double x) {
  printf("%f\n", x);
  return 0;
}
