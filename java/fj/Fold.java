import fj.*;
import fj.data.Array;
import static fj.data.Array.*;
import static fj.Equal.*;

public class Fold {

  public static void main(String[] args) {
    Array<Data> as = array(data(2, 20), data(3, 30), data(4, 40));

    // 1: Original calculation.
    println("as = ", as.toCollection());
    System.out.println("calculate1");
    System.out.println(calculate(as));
    System.out.println();

    // 2: Simpler calculation on manipulated data array.
    Array<Data> bs = array(data(2, 0), data(2, 20), data(3, 20), data(4, 30));
    println("bs = ", bs.toCollection());
    System.out.println("calculate2");
    System.out.println(calculate2(bs));

    // 3: Automate the manipulation of the data array.
    Array<Double> xs = as.map(new F<Data, Double>() {
        public Double f(Data d) { return d.getX(); }
    });
    println("xs = ", xs.toCollection());
    Array<Double> ys = as.map(new F<Data, Double>() {
        public Double f(Data d) { return d.getY(); }
    });
    println("ys = ", ys.toCollection());

    // Duplicate first element of ys.
    Array<Double> ys2 = array(ys.get(0)).append(ys);
    println("ys2 = ", ys2.toCollection());

    // First x is used twice so duplicate it providing a "zero" for y.
    Array<Double> xs2 = array(xs.get(0)).append(xs);
    println("xs2 = ", xs2.toCollection());
    Array<Double> ys3 = array(0.0).append(ys2);
    println("ys3 = ", ys3.toCollection());

    // Zip them back up.
    Array<Data> cs = xs2.zipWith(ys3, new F2<Double, Double, Data>() {
        public Data f(Double x, Double y) { return new Data(x, y); };
    });
    println("cs = ", cs.toCollection());

    // The bs and cs arrays should now be equal.
    println("bs = ", bs.toCollection());
    println("bs.equals(cs) => ", bs.equals(cs)); // XXX: Answer here is surprising.
    F<Data, F<Data, Boolean>> dataEquals = new F<Data, F<Data, Boolean>>() {
      public F<Data, Boolean> f(final Data d1) {
        return new F<Data, Boolean>() {
          public Boolean f(final Data d2) {
            return d1.equals(d2);
          }
        };
      }
    };
    println("bs `equal` cs => ", arrayEqual(equal(dataEquals)).eq(bs, cs));

    println("calculate2(cs) => ", calculate2(cs));
    println("calculate3(cs) => ", calculate3(cs));
  }

  public static class Data {
    Data(double x, double y) { this.x = x; this.y = y; }
    double x,y;
    double getX() { return x; }
    double getY() { return y; }
    public String toString() { return String.format("Data{x=%.1f, y=%.1f}", x, y); };
    public boolean equals(Object o) { Data d = (Data) o; return this.x == d.x && this.y == d.y; }
  }

  private static Data data(double x, double y) {
    return new Data(x, y);
  }

  public static double calculate(Array<Data> data/*, int factor */ /* XXX factor unused */) {
    Data first = data.get(0);
    System.out.println("first = " + first);
    double x = first.getX();
    double y = first.getY();

    for (Data d : data) {
      System.out.println("d = " + d);
      System.out.printf("before x = %f y = %f\n", x, y);
      x *= func1(d.getX() , y);
      y = d.getY();
      System.out.printf("after x = %f y = %f\n", x, y);
      System.out.println();
    }

    return x;
  }

  private static double func1(double x, double y) {
    double result = x + y;
    System.out.println("func1 " + x + " " + y + " => " + result);
    return result;
  }

  private static double calculate2(Array<Data> data) {
    double result = 1;
    for (Data d : data) {
      System.out.println("d = " + d);
      System.out.printf("before result = %f\n", result);
      result *= func1(d.getX() , d.getY());
      System.out.printf("after result = %f\n", result);
      System.out.println();
    }

    return result;
  }

  private static double calculate3(Array<Data> data) {
    F2<Double, Data, Double> f = new F2<Double, Data, Double>() {
      public Double f(Double acc, Data d) {
        System.out.printf("acc = %f d=%s\n", acc, d);
        return acc * func1(d.getX(), d.getY());
      }
    };
    return data.foldLeft(f, 1.0);
  }

  public static void println(Object... args) {
    for (Object a : args) System.out.print(a);
    System.out.println();
  }

}
