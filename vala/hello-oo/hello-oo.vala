class Hello : Object {
  void greeting() {
    stdout.printf("Hello World\n");
  }

  static void main (string[] args) {
    var sample = new Hello();
    sample.greeting();
  }
}
