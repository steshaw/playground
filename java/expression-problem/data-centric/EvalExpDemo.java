public class EvalExpDemo {

  public static void original(EvalExpFactory factory) {
    EvalExpFixed e = ExpDemo.buildOriginal(factory);
    e.print();
    System.out.println(" = " + e.eval());
  }

  public static void next(EvalExpFactory factory) {
    EvalExpFixed e2 = ExpDemo.buildNext(factory);
    e2.print();
    e2.eval();
    System.out.println(" = " + e2.eval());
  }

  public static void main(String[] args) {
    EvalExpFactory factory = new EvalExpFactory();
    original(factory);
    next(factory);
  }

}
