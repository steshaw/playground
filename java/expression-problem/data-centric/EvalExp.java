
interface EvalExp extends Exp {
  int eval();
}

class EvalLit extends Lit implements EvalExp {
  EvalLit(int v) { super(v); }
  public int eval() { return value; }
}

class EvalAdd extends Add implements EvalExp {
  EvalAdd(Exp l, Exp r) { super(l, r); }
  public int eval() { return left.eval() + right.eval(); }
}
