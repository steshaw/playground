package ep.ale4;

interface Exp {                                                  
  void handle(Visitor v);                                        
}                                                                
                                                                    
interface Visitor {                                              
  void apply(Exp e);                                             
  void visitExp(Exp e);                                           
}                                                                
                                                                    
abstract class Node<V extends Visitor> implements Exp { 
  abstract boolean isV(Visitor v); // v instanceof V
  abstract V asV(Visitor v);        // (V)v
  public final void handle(Visitor v) {                          
    if (isV(v)) accept(asV(v));                            
    else v.visitExp(this);                                        
  }                                                              
  abstract void accept(V v);                                     
}                                                                
                                                                    
abstract class Op<E extends Exp> implements Visitor {
  abstract boolean isE(Exp e); // e instanceof E
  abstract E asE(Exp e);       // (E)e
  public final void apply(Exp e) {                               
    if (isE(e)) call(asE(e));                              
    else e.handle(this);                                         
  }                                                              
  abstract void call(E e);                                       
  public void visitExp(Exp e) {                                   
    throw new IllegalArgumentException("Expression problem occurred!");
  }                                                              
}               
