package ep.ale3;

class NaleEval implements NaleVisitor {
  int result;
  <V extends AleVisitor> int eval(Exp<? super V> e, V self) { 
    e.accept(self); return result; 
  }
  public void visitLit(Lit lit) {
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
  int eval(Exp<? super V> e);
}

class NaleEvalDispatcher extends NaleDispatcher implements EvalDispatcher<NaleVisitor> {
  public int eval(Exp<? super NaleVisitor> e) { 
    NaleEval v =  new NaleEval(); return v.eval(e,v); 
  }
}

public class Ext2 extends Ext {
  public static void main(String[] args) {
    NaleEvalDispatcher disp = new NaleEvalDispatcher();
    show(exp2, disp); System.out.println(" = " + disp.eval(exp2));
  }
}
