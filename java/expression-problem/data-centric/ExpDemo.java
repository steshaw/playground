public class ExpDemo {

  public static <T extends Exp<T>> T buildOriginal(IExpFactory<T> f) {
    T lit1 = f.newLit(2);
    T lit2 = f.newLit(3);
    return f.newAdd(lit1, lit2);
  }

  private static void original(ExpFactory f) {
    ExpFixed e = buildOriginal(f);
    e.print();
    System.out.println();
  }

  private static void next(ExpFactory f) {
    ExpFixed e2 = buildNext(f);
    e2.print();
    System.out.println();
  }

  public static <T extends Exp<T>> T buildNext(IExpFactory<T> f) {
    T lit1 = f.newLit(1);
    T lit2 = f.newLit(2);
    T lit3 = f.newLit(3);
    T e1 = f.newAdd(lit1, lit2);
    return f.newAdd(e1, lit3);
  }

  public static void main(String[] args) {
    ExpFactory f = new ExpFactory();
    original(f);
    next(f);
  }

}
