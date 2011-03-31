package ep.ale1;

interface Exp<C extends Exp<C>> { 
  void print(); 
} 

class Lit<C extends Exp<C>> implements Exp<C> { 
  public int value; 
  Lit(int v) { value = v; }
  public void print() { System.out.print(value); } 
} 

class Add<C extends Exp<C>> implements Exp<C> { 
  public C left, right; 
  Add(C l, C r) { left = l; right = r; }
  public void print() { left.print(); System.out.print('+'); right.print(); } 
}

interface AleFactory<C extends Exp<C>> {
  C makeLit(int value);
  C makeAdd(C left, C right);
}

interface ExpF extends Exp<ExpF> {}

class PrintFactory implements AleFactory<ExpF> {
  public ExpF makeLit(int value) {
    class LitF extends Lit<ExpF> implements ExpF {
      LitF(int v) { super(v); }
    }
    return new LitF(value);
  }  
  public ExpF makeAdd(ExpF left, ExpF right) {
    class AddF extends Add<ExpF> implements ExpF {
      AddF(ExpF l, ExpF r) { super(l,r); }
    }
    return new AddF(left,right);
  }  
}

public class Base {
  static <C extends Exp<C>> C build(AleFactory<C> factory) {
    return factory.makeAdd(factory.makeLit(2),factory.makeLit(3));
  }

  static <C extends Exp<C>> void show(C exp) {
    exp.print();
  }

  public static void main(String[] args) {
    show(build(new PrintFactory())); System.out.println();
  }
}
