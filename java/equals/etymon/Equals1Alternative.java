//
// Here I follow the design of Solution1 closely but use isAssignableFrom so that subclasses can be compared.
//

class Equals1Alternative {

  static class A {
    int a;
    A(int a) { this.a = a; }
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
    int b;
    B(int a, int b) { super(a); this.b = b; }
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

  static class C extends B {
    int c;
    C(int a, int b, int c) { super(a, b); this.c = c; }
    public boolean equals(Object o) {
      // If o.class is a strict superclass of C, then "switch arguments" to equals.
      if (o != null && isStrictSuperclass(C.class, o.getClass())) return o.equals(this);

      if (!super.equals(o)) {
        return false;
      } else {
        if (!(o instanceof C)) {
          return false;
        } else {
          C that = (C)o;
          return this.c == that.c;
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

    A c123a = new C(1, 2, 3);
    A c123b = new C(1, 2, 3);

    // eq
    System.out.println("== eq");
    printEqual(a1a, a1a);
    printEqual(b12a, b12a);
    printEqual(c123a, c123a);

    printEqual(a1a, a1b);
    printEqual(a1b, a1a);
    printEqual(a2a, a2b);
    printEqual(a2b, a2a);

    printEqual(b12a, b12b);
    printEqual(b12b, b12a);
    printEqual(b23a, b23b);
    printEqual(b23b, b23a);

    printEqual(c123a, c123b);
    printEqual(c123b, c123a);

    printEqual(a1a, b12a);
    printEqual(b12a, a1a);

    printEqual(a1a, c123a);
    printEqual(c123a, a1a);

    printEqual(b12a, c123a);
    printEqual(c123a, b12a);

    // ne
    System.out.println("== ne");
    printEqual(a1a, null);
    printEqual(b12a, null);
    printEqual(c123a, null);

    printEqual(a1a, a2a);
    printEqual(a2a, a1a);

    printEqual(b12a, b13);
    printEqual(b13,  b12a);

    printEqual(a1a, b23a);
    printEqual(b23a, a1a);

    printEqual(a2a, b12a);
    printEqual(b12a, a2a);

    printEqual(a2a, c123a);
    printEqual(c123a, a2a);

    printEqual(b23a, c123a);
    printEqual(c123a, b23a);
  }
}
