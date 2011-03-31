package ep.ale3;

class Neg<V extends NaleVisitor> implements Exp<V> {             
  public Exp<? super V> exp;   
  Neg(Exp<? super V> e) { exp = e; }                                          
  public void accept(V v) {v.visitNeg(this, v); }                
}                                                                
                                                                    
interface NaleVisitor extends AleVisitor {                       
  <V extends NaleVisitor> void visitNeg(Neg<V> neg, V self);     
}                                                                
                                                                    
class NalePrint extends AlePrint implements NaleVisitor {        
  public <V extends NaleVisitor> void visitNeg(Neg<V> neg, V self){
    System.out.print("-("); neg.exp.accept(self); System.out.print(")"); 
  }                                                              
}                                                                

class NaleDispatcher implements Dispatcher<NaleVisitor> {
  public void print(Exp<? super NaleVisitor> e) { e.accept(new NalePrint()); }
}

public class Ext extends Base {
  static Exp<NaleVisitor> exp2 = new Neg<NaleVisitor>(exp);
  
  public static void main(String[] args) {
    show(exp2, new NaleDispatcher()); System.out.println();
  }
}
