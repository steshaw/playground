public class PrintVisitor implements ExpVisitor {
  public void visitLit(Lit lit) { System.out.print(lit.value); }
  public void visitAdd(Add add) {
    add.left.accept(this);
    System.out.print('+');
    add.right.accept(this);
  }
}
