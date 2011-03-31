public class EvalExpDemo {

  public static void original(EvalExpFactory factory) {
    EvalExpFixed lit1 = factory.newLit(2);
    EvalExpFixed lit2 = factory.newLit(3);
    EvalExpFixed e = factory.newAdd(lit1, lit2);
    e.print();
    System.out.println(" = " + e.eval());
  }

  public static void next(EvalExpFactory factory) {
    EvalExpFixed lit1 = factory.newLit(1);
    EvalExpFixed lit2 = factory.newLit(2);
    EvalExpFixed lit3 = factory.newLit(3);
    EvalExpFixed e1 = factory.newAdd(lit1, lit2);
    EvalExpFixed e2 = factory.newAdd(e1, lit3);
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
