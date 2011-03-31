public class NegateExpDemo {

  public static void original(NegateExpFactory factory) {
    EvalExpFixed e = ExpDemo.buildOriginal(factory);
    e.print();
    System.out.println(" = " + e.eval());

    EvalExpFixed e2 = factory.newNegate(e);
    e2.print();
    System.out.println(" = " + e2.eval());
  }

  public static void next(NegateExpFactory factory) {
    EvalExpFixed e1 = ExpDemo.buildNext(factory);
    e1.print();
    System.out.println(" = " + e1.eval());

    EvalExpFixed e2 = factory.newNegate(e1);
    e2.print();
    System.out.println(" = " + e2.eval());
  }

  public static void negLit(NegateExpFactory f) {
    EvalExpFixed e = f.newNegate(f.newLit(3));
    e.print();
    System.out.println(" = " + e.eval());
  }

  public static void main(String[] args) {
    NegateExpFactory factory = new NegateExpFactory();
    original(factory);
    next(factory);
    negLit(factory);
  }

}
