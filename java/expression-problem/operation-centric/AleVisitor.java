interface AleVisitor {
  void visitLit(Lit lit);
  void visitAdd(Add add);
}

class AlePrint implements AleVisitor {
  public void visitLit(Lit lit) { System.out.print(lit.value); }
  public void visitAdd(Add add) { add.left.accept(this); System.out.print('+'); add.right.accept(this); }
}
