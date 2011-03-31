
interface EvalExp<T extends Exp<T>> extends Exp<T> {
  int eval();
}

/*
class EvalLit extends Lit implements EvalExp {
  EvalLit(int v) { super(v); }
  public int eval() { return value; }
}
*/

class EvalAdd<T extends EvalExp<T>> extends Add<T> implements EvalExp<T> {
  EvalAdd(T l, T r) { super(l, r); }
  public int eval() { return left.eval() + right.eval(); }
}
