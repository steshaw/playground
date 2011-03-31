interface Exp {
  void print();
}

class Lit implements Exp {
  public int value;
  Lit(int v) { value = v; }
  public void print() { System.out.print(value); }
}

class Add implements Exp {
  public Exp left, right;
  Add(Exp l, Exp r) { left = l; right = r; }
  public void print() { left.print(); System.out.print('+'); right.print(); }
}
