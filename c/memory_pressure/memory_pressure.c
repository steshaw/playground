#include <stdio.h>
#include <stdlib.h>

int main(int argc, char *argv[]) {
  // Handle command line args.
  int num;
  if (argc == 2) {
    num = atoi(argv[1]);
  }
  else if (argc == 1) {
    num = 256;
  }
  else {
    fprintf(stderr, "Usage: alloc [size]\n");
    fprintf(stderr, "  size - size in megabytes to allocate\n");
    exit(2);
  }

  const unsigned long ONE_MEG = 1024 * 1024;
  unsigned long mem_to_allocate = ONE_MEG;
  unsigned long total_allocated = 0;

  // Alloc space for memory chunks.
  char **memory = calloc(num, sizeof(char*));
  if (memory == NULL) {
      fprintf(stderr, "calloc failed\n");
      fflush(stderr);
      abort();
  }

  printf("Allocating %d * %gM of RAM\n", num, (double)mem_to_allocate / ONE_MEG);

  for (int i = 0; i < num; ++i) {
    printf("i = %d\n", i);
    char *p = malloc(mem_to_allocate);
    // Update each cell of memory otherwise the system optimises it away (probably OS, could be GCC).
    for (int i = 0; i < mem_to_allocate; ++i) {
      p[i] = i;
    }
    if (p == NULL) {
      fprintf(stderr, "malloc failed\n");
      fflush(stderr);
      abort();
    }
    memory[i] = p;
    printf("allocated another 1M\n");
    total_allocated += ONE_MEG;
    printf("total_allocated = %gM\n", (double)total_allocated / ONE_MEG);
  }

  // Free all.
  for (int i = 0; i < num; ++i) {
    free(memory[i]);
  }
  free(memory);

  return 0;
}
