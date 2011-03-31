
class Negate<T extends EvalExp<T>> implements EvalExp<T> {
  protected T exp;
  Negate(T exp) { this.exp = exp; }
  public void print() { 
    System.out.print("-("); 
    exp.print();
    System.out.print(")");
  }
  public int eval() { return -exp.eval(); }
}

interface INegateExpFactory<T extends EvalExp<T>> extends IExpFactory<T> {
  T newNegate(T exp);
}

class NegateExpFactory extends EvalExpFactory implements INegateExpFactory<EvalExpFixed> {

  static class NegateFixed extends Negate<EvalExpFixed> implements EvalExpFixed {
    NegateFixed(EvalExpFixed e) { super(e); }
  }

  public EvalExpFixed newNegate(EvalExpFixed e) {
    return new NegateFixed(e);
  }
}
