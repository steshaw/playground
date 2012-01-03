class Error {

  int f(int x, int y) { return x+y; }

  int oops() {
    int a = f(3, "4");
    return a;
  }

}
