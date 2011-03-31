package ep.ale1;

class Neg<C extends EvalExp<C>> implements EvalExp<C> {
  C exp;
  Neg(C e) { exp = e; }
  public void print() { 
    System.out.print("-("); exp.print(); System.out.print(")");
  }
  public int eval() { return -exp.eval(); }
}

interface NaleFactory<C extends EvalExp<C>> extends AleFactory<C> {
  C makeNeg(C exp);
}

class NaleEvalFactory extends EvalFactory implements NaleFactory<EvalExpF> {
  public EvalExpF makeNeg(EvalExpF exp) {
    class NegF extends Neg<EvalExpF> implements EvalExpF {
      NegF(EvalExpF e) { super(e); }
    }
    return new NegF(exp);
  }
}

public class Ext2 extends Ext {
  public static void main(String[] args) {
    NaleEvalFactory factory = new NaleEvalFactory();
    EvalExpF exp = factory.makeNeg(build(factory));
    show(exp); System.out.println(" = " + exp.eval());
  }
}
