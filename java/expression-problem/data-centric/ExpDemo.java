public class ExpDemo {
  public static void original() {
    ExpFixed lit1 = Factory.newLit(2);
    ExpFixed lit2 = Factory.newLit(3);
    ExpFixed e = Factory.newAdd(lit1, lit2);
    e.print();
    System.out.println();
  }
  public static void next() {
    ExpFixed lit1 = Factory.newLit(1);
    ExpFixed lit2 = Factory.newLit(2);
    ExpFixed lit3 = Factory.newLit(3);
    ExpFixed e1 = Factory.newAdd(lit1, lit2);
    ExpFixed e2 = Factory.newAdd(e1, lit3);
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
