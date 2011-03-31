class LangF<This extends LangF<This>> {
  interface Visitor<R> {
    public R forNum(int n);
  }
  interface Exp {
    public <R> R visit(This.Visitor<R> v);
  }
  class Num implements Exp {
    protected final int n_;
    public Num(int n) {n_=n;}
    public <R> R visit(This.Visitor<R> v) {
      return v.forNum(n_);
    }
  }
  class Eval implements Visitor<Integer> {
    public Integer forNum(int n) {
      return new Integer(n);
    }
  }
}
final class Lang extends LangF<Lang> {}

class Lang2F<This extends Lang2F<This>> extends LangF<This> {
  interface Visitor<R> extends LangF<This>.Visitor<R> {
    public R forPlus(This.Exp e1, This.Exp e2);
  }
  class Plus implements Exp {
    protected final This.Exp e1_,e2_;
    public Plus(This.Exp e1, This.Exp e2) {e1_=e1; e2_=e2;}
    public <R> R visit(This.Visitor<R> v) {
      return v.forPlus(e1_,e2_);
    }
  }
  class Eval extends LangF<This>.Eval implements Visitor<Integer> {
    public Integer forPlus(This.Exp e1, This.Exp e2) {
      return new Integer(
        e1.visit(this).intValue() + e2.visit(this).intValue()
      );
    }
  }
  class Show implements Visitor<String> {
    public String forNum(int n) {
      return Integer.toString(n);
    }
    public String forPlus(This.Exp e1, This.Exp e2) {
      return "(" + e1.visit(this) + "+" + e2.visit(this) +")";
    }
  }
}
final class Lang2 extends Lang2F<Lang2> {}

final class Main {
  static public void main(String[] args) {
    Lang l = new Lang();
    Lang.Exp e = l.new Num(42);
    System.out.println("eval: " + e.visit(l.new Eval()));
    Lang2 l2 = new Lang2();
    Lang2.Exp e2 = l2.new Plus(l2.new Num(5), l2.new Num(37));
    System.out.println("eval: "+e2.visit(l2.new Eval()));
    System.out.println("show: "+e2.visit(l2.new Show()));
  }
}
