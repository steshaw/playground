#include <algorithm>

int foo() {
#if 0
  int a = 'q';
  a = std::min(a, 'b');
#endif
  int a = 1;
  char b = 'b';
  return std::min(a, b);
}
