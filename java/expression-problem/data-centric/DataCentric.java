public class DataCentric {
  static <T extends Exp<T>> void fred() {
    Exp<T> e = new Add<T>(new Lit(2),new Lit(3));
    e.print();
    System.out.println();
  }
  public static void main(String[] args) {
    fred();
  }
}
