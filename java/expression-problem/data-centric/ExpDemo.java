public class ExpDemo {

  public static <T extends Exp<T>> T buildOriginal(IExpFactory<T> factory) {
    T lit1 = factory.newLit(2);
    T lit2 = factory.newLit(3);
    return factory.newAdd(lit1, lit2);
  }

  public static void original(ExpFactory factory) {
    ExpFixed e = buildOriginal(factory);
    e.print();
    System.out.println();
  }

  public static void next(ExpFactory factory) {
    ExpFixed e2 = buildNext(factory);
    e2.print();
    System.out.println();
  }

  public static <T extends Exp<T>> T buildNext(IExpFactory<T> factory) {
    T lit1 = factory.newLit(1);
    T lit2 = factory.newLit(2);
    T lit3 = factory.newLit(3);
    T e1 = factory.newAdd(lit1, lit2);
    return factory.newAdd(e1, lit3);
  }

  public static void main(String[] args) {
    ExpFactory factory = new ExpFactory();
    original(factory);
    next(factory);
  }
}
