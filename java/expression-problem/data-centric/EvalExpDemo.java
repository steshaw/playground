public class EvalExpDemo {
  public static void original() {
    EvalExpFixed lit1 = EvalExpFactory.newLit(2);
    EvalExpFixed lit2 = EvalExpFactory.newLit(3);
    EvalExpFixed e = EvalExpFactory.newAdd(lit1, lit2);
    e.print();
    System.out.println(" = " + e.eval());
  }
  public static void next() {
    EvalExpFixed lit1 = EvalExpFactory.newLit(1);
    EvalExpFixed lit2 = EvalExpFactory.newLit(2);
    EvalExpFixed lit3 = EvalExpFactory.newLit(3);
    EvalExpFixed e1 = EvalExpFactory.newAdd(lit1, lit2);
    EvalExpFixed e2 = EvalExpFactory.newAdd(e1, lit3);
    e1.print();
    System.out.println(" = " + e1.eval());
    e2.print();
    e2.eval();
    System.out.println(" = " + e2.eval());
  }
  public static void main(String[] args) {
    original();
    next();
  }
}
