#include <stdio.h>

int main(const int argc, const char *argv[]) {
  for (int i = 0; i < argc; ++i) {
    printf("arg[%d] = '%s'\n", i, argv[i]);
  }

  printf("forever loop...");
  for (;;);
}
