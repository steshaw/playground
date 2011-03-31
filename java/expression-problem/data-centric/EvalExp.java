
interface EvalExp<T extends Exp<T>> extends Exp<T> {
  int eval();
}

class EvalLit<T extends EvalExp<T>> extends Lit<T> implements EvalExp<T> {
  EvalLit(int v) { super(v); }
  public int eval() { return value; }
}

class EvalAdd<T extends EvalExp<T>> extends Add<T> implements EvalExp<T> {
  EvalAdd(T l, T r) { super(l, r); }
  public int eval() { return left.eval() + right.eval(); }
}

interface EvalExpFixed extends EvalExp<EvalExpFixed> {}

class EvalExpFactory {
  public EvalExpFixed newLit(int v) {
    class LitFixed extends EvalLit<EvalExpFixed> implements EvalExpFixed {
      LitFixed(int v) { super(v); }
    }
    return new LitFixed(v);
  }

  public EvalExpFixed newAdd(EvalExpFixed left, EvalExpFixed right) {
    class AddFixed extends EvalAdd<EvalExpFixed> implements EvalExpFixed {
      AddFixed(EvalExpFixed e1, EvalExpFixed e2) { super(e1, e2); }
    }
    return new AddFixed(left, right);
  }
}
