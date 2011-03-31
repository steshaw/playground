package ep.ale1;

interface EvalExp<C extends EvalExp<C>> extends Exp<C> {
  int eval();
}

class EvalLit<C extends EvalExp<C>> extends Lit<C> implements EvalExp<C> {
  EvalLit(int v) { super(v); }
  public int eval() { return value; }
}

class EvalAdd<C extends EvalExp<C>> extends Add<C> implements EvalExp<C> {
      EvalAdd(C l, C r) { super(l,r); }
  public int eval() { return left.eval()+right.eval(); }
}

interface EvalExpF extends EvalExp<EvalExpF> {}

class EvalFactory implements AleFactory<EvalExpF> {
  public EvalExpF makeLit(int value) {
    class LitF extends EvalLit<EvalExpF> implements EvalExpF {
      LitF(int v) { super(v); }
    }
    return new LitF(value);
  }
  public EvalExpF makeAdd(EvalExpF left, EvalExpF right) {
    class AddF extends EvalAdd<EvalExpF> implements EvalExpF {
      AddF(EvalExpF l, EvalExpF r) { super(l,r); }
    }
    return new AddF(left,right);
  }
}

public class Ext {
  public static void main(String[] args) {
    EvalExpF exp = Base.build(new EvalFactory());
    Base.show(exp); System.out.println(" = " + exp.eval());
  }
}
