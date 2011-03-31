
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

interface IExpFactory<T extends Exp<T>> {
  T newLit(int v);
  T newAdd(T left, T right);
}

class ExpFactory implements IExpFactory<ExpFixed> {

  static class LitFixed extends Lit<ExpFixed> implements ExpFixed {
    LitFixed(int v) { super(v); }
  }

  public ExpFixed newLit(int v) {
    return new LitFixed(v);
  }

  static class AddFixed extends Add<ExpFixed> implements ExpFixed {
    AddFixed(ExpFixed e1, ExpFixed e2) { super(e1, e2); }
  }

  public ExpFixed newAdd(ExpFixed left, ExpFixed right) {
    return new AddFixed(left, right);
  }
}
