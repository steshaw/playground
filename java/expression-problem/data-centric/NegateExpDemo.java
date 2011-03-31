public class NegateExpDemo {

  public static void original(NegateExpFactory f) {
    EvalExpFixed e = ExpDemo.buildOriginal(f);
    e.print();
    System.out.println(" = " + e.eval());

    EvalExpFixed e2 = f.newNegate(e);
    e2.print();
    System.out.println(" = " + e2.eval());
  }

  public static void next(NegateExpFactory f) {
    EvalExpFixed e1 = ExpDemo.buildNext(f);
    e1.print();
    System.out.println(" = " + e1.eval());

    EvalExpFixed e2 = f.newNegate(e1);
    e2.print();
    System.out.println(" = " + e2.eval());
  }

  public static void negLit(NegateExpFactory f) {
    EvalExpFixed e = f.newNegate(f.newLit(3));
    e.print();
    System.out.println(" = " + e.eval());
  }

  public static void main(String[] args) {
    NegateExpFactory f = new NegateExpFactory();
    original(f);
    next(f);
    negLit(f);
  }

}
