interface Exp {
  void accept(AleVisitor v);
}

class Lit implements Exp {
  public int value;
  Lit(int v) { value = v; }
  public void accept(AleVisitor v) { v.visitLit(this); }
}

class Add implements Exp {
  public Exp left, right;
  Add(Exp l, Exp r) { left = l; right = r; }
  public void accept(AleVisitor v) { v.visitAdd(this); }
}

interface AleVisitor {
  void visitLit(Lit lit);
  void visitAdd(Add add);
}

class AlePrint implements AleVisitor {
  public void visitLit(Lit lit) { System.out.print(lit.value); }
  public void visitAdd(Add add) { add.left.accept(this); System.out.print('+'); add.right.accept(this); }
}

public class OperationCentric {
  public static void main(String[] args) {
    Exp e = new Add(new Lit(2),new Lit(3));
    e.accept(new AlePrint());
    System.out.println();
  }
}
