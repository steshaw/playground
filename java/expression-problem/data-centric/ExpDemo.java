public class ExpDemo {
  public static void original() {
    ExpFixed lit1 = ExpFactory.newLit(2);
    ExpFixed lit2 = ExpFactory.newLit(3);
    ExpFixed e = ExpFactory.newAdd(lit1, lit2);
    e.print();
    System.out.println();
  }
  public static void next() {
    ExpFixed lit1 = ExpFactory.newLit(1);
    ExpFixed lit2 = ExpFactory.newLit(2);
    ExpFixed lit3 = ExpFactory.newLit(3);
    ExpFixed e1 = ExpFactory.newAdd(lit1, lit2);
    ExpFixed e2 = ExpFactory.newAdd(e1, lit3);
    e1.print();
    System.out.println();
    e2.print();
    System.out.println();
  }
  public static void main(String[] args) {
    original();
    next();
  }
}
