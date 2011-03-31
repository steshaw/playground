public class ExpDemo {

  public static ExpFixed buildOriginal(ExpFactory factory) {
    ExpFixed lit1 = factory.newLit(2);
    ExpFixed lit2 = factory.newLit(3);
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

  private static ExpFixed buildNext(ExpFactory factory) {
    ExpFixed lit1 = factory.newLit(1);
    ExpFixed lit2 = factory.newLit(2);
    ExpFixed lit3 = factory.newLit(3);
    ExpFixed e1 = factory.newAdd(lit1, lit2);
    return factory.newAdd(e1, lit3);
  }

  public static void main(String[] args) {
    ExpFactory factory = new ExpFactory();
    original(factory);
    next(factory);
  }
}
