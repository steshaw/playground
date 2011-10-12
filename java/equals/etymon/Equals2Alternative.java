//
// Equals solution 2 from http://etymon.blogspot.com/2004/08/objectequals.html
//
// but following along the pattern from Equals1Alternative
//
// FIXME: This shows that the pattern from Equals1Alternative is buggy!
//

class Equals2Alternative {

  static abstract class Shape {
    public boolean equals(Object o) {
      if (super.equals(o)) {
        return true;
      } else {
        if (!(o instanceof Shape)) {
          return false;
        } else {
          Shape that = (Shape)o;
          return /*[shape specific comparison --- maybe position]*/ true;
        }
      }
    }
  }

  static class Ellipse extends Shape { 
    int minor, major;
    Ellipse(int major, int minor) {
      this.major = major;
      this.minor = minor;
    }

    public int getMinor() { return minor; }
    public int getMajor() { return major; }

    // !!! NOTE THE USE OF *final* to prevent asymmetry!
    // Also note the exclusive use of accessors.
    public final boolean equals(Object o) {
      if (super.equals(o)) {
        return true;
      } else {
        if (!(o instanceof Ellipse)) {
          return false;
        } else {
          Ellipse that = (Ellipse)o;
          return this.getMajor() == that.getMajor()
              && this.getMinor() == that.getMinor();
        }
      }
    }
  }

  static class Circle extends Ellipse {
    public Circle(int radius) { super(radius, radius); }
    public int getRadius()    { return major; }
  }

  static void printEqual(Ellipse e1, Ellipse e2) {
    if (e1.equals(e2)) {
      System.out.println("eq");
    } else {
      System.out.println("ne");
    }
  }

  // And test it:
  public static void main(String[] args) {
    Ellipse e22a = new Ellipse(2, 2);
    Ellipse e22b = new Ellipse(2, 2);
    Ellipse e23a = new Ellipse(2, 3);
    Ellipse e23b = new Ellipse(2, 3);
    Ellipse c2a = new Circle(2);
    Ellipse c2b = new Circle(2);

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
