//
// Here I follow the design of Solution1 closely but use isAssignableFrom so that subclasses can be compared.
//

class Equals1Alternative {

  static class A {
    int n1;
    public boolean equals(Object o) {
      if (super.equals(o)) {
        return true;
      } else {
        if (!(o instanceof A)) {
          return false;
        } else {
          A that = (A)o;
          return this.n1 == that.n1;
        }
      }
    }
  }

  static class B extends A { 
    int n2;
    public boolean equals(Object o) {
      if (super.equals(o)) {
        return true;
      } else {
        if (!(o instanceof B)) {
          return false;
        } else {
          B that = (B)o;
          return this.n2 == that.n2;
        }
      }
    }
  }

  static void printEqual(A a1, A a2) {
    if (a1.equals(a2)) {
      System.out.println("eq");
    } else {
      System.out.println("ne");
    }
  }

  // And test it:
  public static void main(String[] args) {
    A test1 = new A();
    A test2 = new B();
    printEqual(test1, test1); // => "eq"
    printEqual(test2, test2); // => "eq"
    printEqual(test1, test2); // => "eq"
    printEqual(test2, test1); // => "eq"
    printEqual(test1, null);  // => "ne"
    printEqual(test2, null);  // => "ne"
  }
}
