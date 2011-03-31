package ep.ale2;

interface Exp<V extends AleVisitor> {                            
  void accept(V v);                                              
}                                                                
                                                                    
class Lit<V extends AleVisitor> implements Exp<V> {              
  public int value;      
  Lit(int v) { value = v; }                                        
  public void accept(V v) {v.visitLit(this); }                   
}                                                                
                                                                    
class Add<V extends AleVisitor> implements Exp<V> {              
  public Exp<V> left, right;
  Add(Exp<V> l, Exp<V> r) { left = l; right = r; }
  public void accept(V v) {v.visitAdd(this, v); }                
}
 
interface AleVisitor {                                           
  <V extends AleVisitor> void visitLit(Lit<V> lit);
  <V extends AleVisitor> void visitAdd(Add<V> add, V self);
}
                                                                    
class AlePrint implements AleVisitor {                           
  public <V extends AleVisitor> void visitLit(Lit<V> lit) {      
    System.out.print(lit.value);                                 
  }
  public <V extends AleVisitor> void visitAdd(Add<V> add, V self){
    add.left.accept(self); System.out.print('+'); add.right.accept(self);
  }
}

interface Dispatcher<V extends AleVisitor> {
  void print(Exp<V> e);
}

class AleDispatcher implements Dispatcher<AleVisitor> {
  public void print(Exp<AleVisitor> e) { e.accept(new AlePrint()); }
}

public class Base {
  static <V extends AleVisitor> Exp<V> build() {
    return new Add<V>(new Lit<V>(2), new Lit<V>(3));
  }

  static <V extends AleVisitor> void show(Exp<V> exp, Dispatcher<V> disp) {
    disp.print(exp);
  }

  public static void main(String[] args) {
    show(build(), new AleDispatcher()); System.out.println();
  }
}
