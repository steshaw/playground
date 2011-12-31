#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <pthread.h>

void thread_main(const char name[]) {
  for (;;) {
    printf("thread %s\n", name);
    sleep(1000);
  }
}

typedef void *(*ThreadStart)(void *);

int main(void) {
  pthread_attr_t attr;
  size_t stacksize;
  pthread_attr_init(&attr);
  pthread_attr_getstacksize (&attr, &stacksize);
  printf("Default stack size = %zuk\n", stacksize/1024);

  int i = 0;
  pthread_t thread = NULL;
  for (;;) {
    ++i;
    char *name = malloc(10); // XXX: oops -cannot be freed until thread terminates.
    sprintf(name, "thread%d", i);
    size_t stackSize = 4 * 1024;
    int setStackStatus = pthread_attr_setstacksize(&attr, stackSize);
    if (setStackStatus == 0) {
      printf("Cannot set stack size of %zu\n", stackSize);
      exit(-1);
    }
    int createStatus = pthread_create(&thread, &attr, (ThreadStart) thread_main, name);
    if (createStatus != 0) break;
  }
  return 0;
}
