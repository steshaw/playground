//
// From http://blog.llvm.org/2011/05/what-every-c-programmer-should-know_14.html
//
// This code traps with 'Illegal instruction' if compiled with:
//
//   $ clang t.c -fcatch-undefined-behavior
//
// Don't be confused with the British spelling "behaviour":
//
//   $ clang t.c -fcatch-undefined-behaviour
//
// as "-f" arguments that are not defined are not rejected by the compiler.
//

int foo(int i) {
  int x[2];
  x[i] = 12;
  return x[i];
}

int main() {
  return foo(2);
}
