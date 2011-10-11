//
// Solution 1 from http://etymon.blogspot.com/2004/08/objectequals.html
//
// This solution for the equals method means that instances of class A will never be equals to instances of class B
// This could be ok but sometimes surprising.
//

class Equals1 {

  static class A {
    int n1;
    public boolean equals(Object o) {
      if (o == this) {
        return true;
      } else if (o == null || !getClass().equals(o.getClass())) {
        return false;
      } else {
        A rhs = (A)o;
        return this.n1 == rhs.n1;
      }
    }
  }

  static class B extends A { 
    int n2;
    public boolean equals(Object o) {
      if (!super.equals(o)) {
        return false;
      } else {
        B rhs = (B)o;
        return this.n2 == rhs.n2;
      }
    }
  }

  static void printEqual(A a1, A a2) {
    if (a1.equals(a2)) {
      System.out.println("EQUAL");
    } else {
      System.out.println("NOT-EQUAL");
    }
  }

  // And test it:
  public static void main(String[] args) {
    A test1 = new A();
    A test2 = new B();
    printEqual(test1, test2);
    //    => Prints "NOT-EQUAL"
    printEqual(test2, test1);
    //    => Prints "NOT-EQUAL"
  }
}
