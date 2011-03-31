package ep.ale2;

class Neg<V extends NaleVisitor> implements Exp<V> {             
  public Exp<V> exp;
  Neg(Exp<V> e) { exp = e; }
  public void accept(V v) {v.visitNeg(this, v); }                
}                                                                
                                                                    
interface NaleVisitor extends AleVisitor {                       
  <V extends NaleVisitor> void visitNeg(Neg<V> neg, V self);     
}                                                                
                                                                    
class NalePrint extends AlePrint implements NaleVisitor {        
  public <V extends NaleVisitor> void visitNeg(Neg<V> neg, V self) {
    System.out.print("-("); neg.exp.accept(self); System.out.print(")"); 
  }
}

class NaleDispatcher implements Dispatcher<NaleVisitor> {
  public void print(Exp<NaleVisitor> e) { e.accept(new NalePrint()); }
}

public class Ext extends Base {
  static <V extends NaleVisitor> Exp<V> build2() { 
    return new Neg<V>(Base.<V>build()); 
  }
  
  public static void main(String[] args) {
    show(build2(), new NaleDispatcher()); System.out.println();
  }
}
