//
// Equals solution 3 from http://etymon.blogspot.com/2004/08/objectequals.html
//
// With fix applied to EllipseBase.equals.
// 

class Equals3 {

  public static abstract class EllipseBase {
    public abstract int getMajor();
    public abstract int getMinor();
    public final boolean equals(Object o) {
      if (!(o instanceof EllipseBase)) {
        return false;
      } else {
        EllipseBase that = (EllipseBase)o;
        return this.getMajor() == that.getMajor()
            && this.getMinor() == that.getMinor();
      }
    }
  }

  public static class Ellipse extends EllipseBase {
    int major, minor;
    Ellipse(int major, int minor) {
      this.major = major;
      this.minor = minor;
    }
    public int getMajor() { return major; }
    public int getMinor() { return minor; }
  }

  public static class Circle extends EllipseBase {
    int radius;
    Circle(int radius) {
      this.radius = radius;
    }

    public int getMajor() { return radius; }
    public int getMinor() { return radius; }
  }

  static void printEqual(EllipseBase e1, EllipseBase e2) {
    if (e1.equals(e2)) {
      System.out.println("eq");
    } else {
      System.out.println("ne");
    }
  }

  // And test it:
  public static void main(String[] args) {
    EllipseBase e22a = new Ellipse(2, 2);
    EllipseBase e22b = new Ellipse(2, 2);
    EllipseBase e23a = new Ellipse(2, 3);
    EllipseBase e23b = new Ellipse(2, 3);
    EllipseBase c2a = new Circle(2);
    EllipseBase c2b = new Circle(2);

    printEqual(e22a, e22a);
    printEqual(e22b, e22b);
    printEqual(e22a, e22b);
    printEqual(e22b, e22a);

    printEqual(c2a, c2a);
    printEqual(c2b, c2b);
    printEqual(c2a, c2b);
    printEqual(c2b, c2a);

    printEqual(c2a, e22a);
    printEqual(e22a, c2a);

    printEqual(e22a, null);
    printEqual(c2a, null);

    printEqual(c2a, e23a);
    printEqual(e23a, c2a);
  }
}
