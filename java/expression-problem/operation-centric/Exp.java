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
