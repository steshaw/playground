package ep.ale4;

interface PrintExp extends Exp {                                             
  void print(Print print);                                       
}                                                                
                                                                    
class Print extends Op<PrintExp> implements Visitor {
  boolean isE(Exp e) { return (e instanceof PrintExp); }
  PrintExp asE(Exp e) { return (PrintExp)e; }
  void call(PrintExp e) {e.print(this); }                        
}                                                                
                   
abstract class AleNode extends Node<AleVisitor> implements PrintExp {
  boolean isV(Visitor v) { return (v instanceof AleVisitor); }
  AleVisitor asV(Visitor v) { return (AleVisitor)v; }
}

class Lit extends AleNode {    
  public int value;    
  Lit(int v) { value = v; }                                          
  public void print(Print print) {System.out.print(value); }     
  void accept(AleVisitor v) {v.visitLit(this); }                 
}                                                                
                                                                    
class Add extends AleNode {
  public Exp left, right;
  Add(Exp l, Exp r) { left = l; right = r; }
  public void print(Print print) {                               
    print.apply(left); System.out.print('+'); print.apply(right);
  }                                                              
  void accept(AleVisitor v) {v.visitAdd(this); }                 
}                                                                
                                                                    
interface AleVisitor extends Visitor {                           
  void visitLit(Lit lit);                                        
  void visitAdd(Add add);                                        
}     

public class Base {
  static Exp exp = new Add(new Lit(2), new Lit(3));
  static Visitor print = new Print();

  static void show(Exp e) { print.apply(e); }
  
  public static void main(String[] args) {
    show(exp); System.out.println();
  }
}
