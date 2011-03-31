package ep.ale2;

class NaleEval implements NaleVisitor {
  int result;
  <V extends AleVisitor> int eval(Exp<V> e, V self) { 
    e.accept(self); return result; 
  }
  public <V extends AleVisitor> void visitLit(Lit<V> lit) {
    result = lit.value;
  }
  public <V extends AleVisitor> void visitAdd(Add<V> add, V self){
    result = eval(add.left, self) + eval(add.right, self);
  }
  public <V extends NaleVisitor> void visitNeg(Neg<V> neg, V self) {
    result = -eval(neg.exp, self);
  }
}

interface EvalDispatcher<V extends NaleVisitor> extends Dispatcher<V> {
  int eval(Exp<V> e);
}

class NaleEvalDispatcher extends NaleDispatcher implements EvalDispatcher<NaleVisitor> {
  public int eval(Exp<NaleVisitor> e) { 
    NaleEval v =  new NaleEval(); return v.eval(e,v); 
  }
}

public class Ext2 extends Ext {
  public static void main(String[] args) {
    Exp<NaleVisitor> exp = build2();
    NaleEvalDispatcher disp = new NaleEvalDispatcher();
    show(exp, disp); System.out.println(" = " + disp.eval(exp));
  }
}
