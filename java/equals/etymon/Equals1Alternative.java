//
// Here I follow the design of Solution1 closely but use isAssignableFrom so that subclasses can be compared.
//

class Equals1Alternative {

  static class A {
    A(int a) { this.a = a; }
    int a;
    public boolean equals(Object o) {
      if (super.equals(o)) {
        // At the bottom of the heirarchy, return true if Object.equals is true. i.e. ==
        return true;
      } else {
        if (!(o instanceof A)) {
          return false;
        } else {
          A that = (A)o;
          return this.a == that.a;
        }
      }
    }
  }

  static boolean isStrictSuperclass(Class<?> a, Class<?> b) {
    return (b.isAssignableFrom(a) && b != a);
  }

  static class B extends A {
    B(int a, int b) { super(a); this.b = b; }
    int b;
    public boolean equals(Object o) {
      // If o.class is a strict superclass of B, then "switch arguments" to equals.
      if (o != null && isStrictSuperclass(B.class, o.getClass())) return o.equals(this);

      if (!super.equals(o)) {
        return false;
      } else {
        if (!(o instanceof B)) {
          return false;
        } else {
          B that = (B)o;
          return this.b == that.b;
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
    A a1a = new A(1);
    A a1b = new A(1);
    A a2a = new A(2);
    A a2b = new A(2);
    A b12a = new B(1, 2);
    A b12b = new B(1, 2);
    A b13 = new B(1, 3);
    A b23a = new B(2, 3);
    A b23b = new B(2, 3);

    // eq
    printEqual(a1a, a1a);
    printEqual(b12a, b12a);
    printEqual(a1a, b12a);
    printEqual(b12a, a1a);

    printEqual(a1a, a1a);
    printEqual(b12a, b12a);
    printEqual(a1a, b12a);
    printEqual(b12a, a1a);

    printEqual(a1a, a1b);
    printEqual(a1b, a1a);
    printEqual(a2a, a2b);
    printEqual(a2b, a2a);

    printEqual(b12a, b12b);
    printEqual(b12b, b12a);
    printEqual(b23a, b23b);
    printEqual(b23b, b23a);

    // ne
    printEqual(a1a, null);
    printEqual(b12a, null);

    printEqual(a1a, a2a);
    printEqual(a2a, a1a);

    printEqual(b12a, b13);
    printEqual(b13,  b12a);

    printEqual(a1a, b23a);
    printEqual(b23a, a1a);
    printEqual(a2a, b12a);
    printEqual(b12a, a2a);
  }
}
