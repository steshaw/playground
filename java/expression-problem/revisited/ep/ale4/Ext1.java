package ep.ale4;

class Eval extends Op<EvalExp> implements AleVisitor {
  boolean isE(Exp e) { return (e instanceof EvalExp); }
  EvalExp asE(Exp e) { return (EvalExp)e; }
  int result;                                                    
  public final int eval(Exp e) {apply(e); return result; }       
  void call(EvalExp e) { result = e.eval(this); }                 
  public void visitLit(Lit lit) { result = lit.value; }           
  public void visitAdd(Add add) { result = eval(add.left) + eval(add.right); }
}

interface EvalExp extends PrintExp {                             
  int eval(Eval eval);                                           
}

public class Ext1 extends Base {
  static Eval eval = new Eval();

  public static void main(String[] args) {
    show(exp); System.out.println(" = " + eval.eval(exp));
  }
}
