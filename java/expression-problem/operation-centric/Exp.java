interface Exp {
  void accept(ExpVisitor v);
}

interface ExpVisitor {
  void visitLit(Lit lit);
  void visitAdd(Add add);
}

class Lit implements Exp {
  public int value;
  Lit(int v) { value = v; }
  public void accept(ExpVisitor v) { v.visitLit(this); }
}

class Add implements Exp {
  public Exp left, right;
  Add(Exp l, Exp r) { left = l; right = r; }
  public void accept(ExpVisitor v) { v.visitAdd(this); }
}
