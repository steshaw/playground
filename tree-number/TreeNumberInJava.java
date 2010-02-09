package steshaw;

import static java.lang.Math.max;

/**
 * @see http://blog.tmorris.net/dear-java-guy-state-is-a-monad/
 */
public class TreeNumberInJava {

  /**
   * a Function type
   */
  interface F<A, B> { public B f(A a); }

  /**
   * Tree algebraic data type using Church encoding
   * @see http://apocalisp.wordpress.com/2009/08/21/structural-pattern-matching-in-java/
   */
  public static abstract class Tree {

    // Constructor private so the type is sealed.
    private Tree() {}

    public abstract <T> T match(F<Empty, T> a, F<Leaf, T> b, F<Branch, T> c);

    public static final class Empty extends Tree {
      public <T> T match(F<Empty, T> a, F<Leaf, T> b, F<Branch, T> c) {
        return a.f(this);
      }

      public Empty() {}
    }

    public static final class Leaf extends Tree {
      public final int n;

      public <T> T match(F<Empty, T> a, F<Leaf, T> b, F<Branch, T> c) {
        return b.f(this);
      }

      public Leaf(int n) { this.n = n; }
    }

    public static final class Branch extends Tree {
      public final Tree left;
      public final Tree right;    

      public <T> T match(F<Empty, T> a, F<Leaf, T> b, F<Branch, T> c) {
        return c.f(this);
      }

      public Branch(Tree left, Tree right) {
        this.left = left; this.right = right;
      }
    }
  }

  interface Pair<A, B> {
    A first();
    B second();
  }

  static class Pairs {
    public static <A, B> Pair<A, B> pair(final A a, final B b) {
      return new Pair<A, B>() {
        public A first() { return a; }
        public B second() { return b; }
        public String toString() {
          return "(" + a + ":" + a.getClass().getName() + ", " + b + ":" + b.getClass().getName() + ")";
        }
      };
    }
  }

  interface State<S, A> {
    Pair<S, A> run(S s);
  }

  interface Function<X, Y> {
    Y apply(X x);
  }

  static class States {

    // State<S, _> is a covariant functor
    public static <S, A, B> State<S, B> map(final State<S, A> s, final Function<A, B> f) {
      return new State<S, B>() {
        public Pair<S, B> run(final S k) {
          final Pair<S, A> p = s.run(k);
          return Pairs.pair(p.first(), f.apply(p.second()));
        }
      };
    }

    // // State<S, _> is a monad
    public static <S, A, B> State<S, B> bind(final State<S, A> s, final Function<A, State<S, B>> f) {
      return new State<S, B>() {
        public Pair<S, B> run(final S k) {
          final Pair<S, A> p = s.run(k);
          return f.apply(p.second()).run(p.first());
        }
      };
    }
  }

  public static <Ignore> F<Ignore, Integer> constant(final Integer i) {
    return new F<Ignore, Integer>() {
      public Integer f(Ignore ignore) { return i; };
    };
  }

  private static F<Tree.Empty, Integer> zeroOnEmpty = new F<Tree.Empty, Integer>() {
    public Integer f(Tree.Empty tree) {
      return 0;
    }
  };
  private static F<Tree.Leaf, Integer> oneOnLeaf = new F<Tree.Leaf, Integer>() {
    public Integer f(Tree.Leaf tree) {
      return 1;
    }
  };

  public static int depth(Tree t) {
    //return t.match(constant<Tree.Empty>(0), constant<Tree.Leaf>(1), new F<Tree.Branch, Integer>(){
    return t.match(zeroOnEmpty, oneOnLeaf, new F<Tree.Branch, Integer>(){
      public Integer f(Tree.Branch n) {
        return 1 + max(depth(n.left), depth(n.right));
      }
    });
  }

  public static void println(String s) {
    System.out.println(s);
  }

  public static void main(String[] args) {

    Tree t1 = new Tree.Branch(new Tree.Branch(new Tree.Leaf(2), new Tree.Leaf(6)), new Tree.Leaf(9));
    Tree t2 = new Tree.Branch(new Tree.Branch(new Tree.Leaf(2), new Tree.Branch(new Tree.Leaf(4), new Tree.Leaf(5))), new Tree.Leaf(9));

    println("depth of t1 " + depth(t1));
    println("depth of t2 " + depth(t2));

    State<Double, String> state0 = new State<Double, String>() {
      public Pair<Double, String> run(Double s) {
        return Pairs.pair(s, "9");
      }
    };
    System.out.println("state0 = " + state0.run(1.0));

    State<Double, Integer> state1 = States.map(state0, new Function<String, Integer>() {
      public Integer apply(String x) {
        return Integer.valueOf(x) - 5;
      }
    });
    System.out.println("state1 = " + state1.run(1.0));

    State<Double, String> state2 = States.bind(state1, new Function<Integer, State<Double, String>>() {
      public State<Double, String> apply(final Integer a) {
        return new State<Double, String>() {
          public Pair<Double, String> run(Double s) {
            return Pairs.pair(s + 0.1, "'" + a.toString() + "'");
          }
        };
      }
    });
    System.out.println("state2 = " + state2.run(1.0));
  }

}
