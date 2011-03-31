
interface Exp<T extends Exp<T>> {
  void print();
}

class Lit<T extends Exp<T>> implements Exp<T> {
  protected int value;
  Lit(int v) { value = v; }
  public void print() { System.out.print(value); }
}

class Add<T extends Exp<T>> implements Exp<T> {
  protected T left, right;
  Add(T l, T r) { left = l; right = r; }
  public void print() { left.print(); System.out.print('+'); right.print(); }
}

interface ExpFixed extends Exp<ExpFixed> {}

class Factory {
  public static ExpFixed newLit(int v) {
    class LitFixed extends Lit<ExpFixed> implements ExpFixed {
      LitFixed(int v) { super(v); }
    }
    return new LitFixed(v);
  }

  public static ExpFixed newAdd(ExpFixed left, ExpFixed right) {
    class AddFixed extends Add<ExpFixed> implements ExpFixed {
      AddFixed(ExpFixed e1, ExpFixed e2) { super(e1, e2); }
    }
    return new AddFixed(left, right);
  }
}
