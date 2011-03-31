package ep.ale3;

interface Exp<V extends AleVisitor> {                            
  void accept(V v);                                              
}                                                                
                                                                    
class Lit implements Exp<AleVisitor> {                           
  public int value;
  Lit(int v) { value = v; }
  public void accept(AleVisitor v) {v.visitLit(this); }          
}                                                                
                                                                    
class Add<V extends AleVisitor> implements Exp<V> {              
  public Exp<? super V> left, right;   
  Add(Exp<? super V> l, Exp<? super V> r) { left = l; right = r; }
  public void accept(V v) {v.visitAdd(this, v); }                
}                                                                
                                                                    
interface AleVisitor {                                           
  void visitLit(Lit lit);                                        
  <V extends AleVisitor> void visitAdd(Add<V> add, V self);      
}                                                                
                                                                    
class AlePrint implements AleVisitor {                           
  public void visitLit(Lit lit) {System.out.print(lit.value); }  
  public <V extends AleVisitor> void visitAdd(Add<V> add, V self){
    add.left.accept(self); System.out.print('+'); add.right.accept(self);
  }                                                              
}                                                                

interface Dispatcher<V extends AleVisitor> {
  void print(Exp<? super V> e);
}

class AleDispatcher implements Dispatcher<AleVisitor> {
  public void print(Exp<? super AleVisitor> e) { e.accept(new AlePrint()); }
}

public class Base {
  static Exp<AleVisitor> exp = 
    new Add<AleVisitor>(new Lit(2), new Lit(3));

  static <V extends AleVisitor> void show(Exp<? super V> exp, Dispatcher<V> disp) {
    disp.print(exp);
  }

  public static void main(String[] args) {
    show(exp, new AleDispatcher()); System.out.println();
  }
}
