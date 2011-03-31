interface Exp<T extends Exp<T>> {
  void print();
}

class Lit implements Exp {
  protected int value;
  Lit(int v) { value = v; }
  public void print() { System.out.print(value); }
}

class Add<T extends Exp<T>> implements Exp<T> {
  protected T left, right;
  Add(T l, T r) { left = l; right = r; }
  public void print() { left.print(); System.out.print('+'); right.print(); }
}
