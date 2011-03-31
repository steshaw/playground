package ep.ale4;

class Neg extends Node<NaleVisitor> implements EvalExp {  
  boolean isV(Visitor v) { return (v instanceof NaleVisitor); }
  NaleVisitor asV(Visitor v) { return (NaleVisitor)v; }       
  public Exp exp;
  Neg(Exp e) { exp = e; }
  public void print(Print print) { System.out.print('-'); print.apply(exp); }
  public int eval(Eval eval) { return -eval.eval(exp); }          
  void accept(NaleVisitor v) { v.visitNeg(this); }                
}                                                                
                                                                    
interface NaleVisitor extends AleVisitor {                       
  void visitNeg(Neg neg);                                        
}                 

public class Ext2 extends Ext1 {
  static Exp exp2 = new Neg(exp);

  public static void main(String[] args) {
    show(exp2); System.out.println(" = " + eval.eval(exp2));
  }
}
