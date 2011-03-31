public class EvalExpDemo {

  public static void original(EvalExpFactory f) {
    EvalExpFixed e = ExpDemo.buildOriginal(f);
    e.print();
    System.out.println(" = " + e.eval());
  }

  public static void next(EvalExpFactory f) {
    EvalExpFixed e2 = ExpDemo.buildNext(f);
    e2.print();
    e2.eval();
    System.out.println(" = " + e2.eval());
  }

  public static void main(String[] args) {
    EvalExpFactory f = new EvalExpFactory();
    original(f);
    next(f);
  }

}
