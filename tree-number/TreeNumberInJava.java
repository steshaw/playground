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
   * Geneified Tree algebraic data type using Church encoding
   * @see http://apocalisp.wordpress.com/2009/08/21/structural-pattern-matching-in-java/
   */
  public static abstract class Tree<A> {

    // Constructor private so the type is sealed.
    private Tree() {}

    public abstract <T> T match(F<Empty<A>, T> a, F<Leaf<A>, T> b, F<Branch<A>, T> c);

    public static final class Empty<A> extends Tree<A> {
      public <T> T match(F<Empty<A>, T> a, F<Leaf<A>, T> b, F<Branch<A>, T> c) {
        return a.f(this);
      }

      public Empty() {}
    }

    public static final class Leaf<A> extends Tree<A> {
      public final A a;

      public <T> T match(F<Empty<A>, T> a, F<Leaf<A>, T> b, F<Branch<A>, T> c) {
        return b.f(this);
      }

      public Leaf(A a) { this.a = a; }
    }

    public static final class Branch<A> extends Tree<A> {
      public final Tree<A> left;
      public final Tree<A> right;

      public <T> T match(F<Empty<A>, T> a, F<Leaf<A>, T> b, F<Branch<A>, T> c) {
        return c.f(this);
      }

      public Branch(Tree<A> left, Tree<A> right) {
        this.left = left; this.right = right;
      }
    }
  }

  static class Trees {
    public static <A> Tree.Empty<A> empty() {
      return new Tree.Empty<A>();
    }
    public static <A> Tree.Leaf<A> node(A a) {
      return new Tree.Leaf<A>(a);
    }
    public static <A> Tree.Branch<A> branch(Tree<A> left, Tree<A> right) {
      return new Tree.Branch<A>(left, right);
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

  public static <Ignore, B> F<Ignore, B> constant(final B b) {
    return new F<Ignore, B>() {
      public B f(Ignore ignore) { return b; };
    };
  }

  private static <A> F<Tree.Empty<A>, Integer> zeroOnEmpty() {
      return new F<Tree.Empty<A>, Integer>() {
        public Integer f(Tree.Empty<A> tree) {
          return 0;
        }
      };
  }

  private static <A> F<Tree.Leaf<A>, Integer> oneOnLeaf() {
      return new F<Tree.Leaf<A>, Integer>() {
        public Integer f(Tree.Leaf tree) {
          return 1;
        }
      };
  }

  public static <A> int depth(Tree<A> t) {
    //return t.match(constant(0), constant(1), new F<Tree.Branch<A>, Integer>(){
    return t.match(new F<Tree.Empty<A>, Integer>() {
      public Integer f(Tree.Empty<A> t) {
          return 0;
      }
    }, new F<Tree.Leaf<A>, Integer>() {
      public Integer f(Tree.Leaf<A> t) {
          return 1;
      }
    }, new F<Tree.Branch<A>, Integer>() {
      public Integer f(Tree.Branch<A> n) {
        return 1 + max(depth(n.left), depth(n.right));
      }
    });
  }

  public static void println(String s) {
    System.out.println(s);
  }

/*
  public static number(seed: Int): (Tree[(A, Int)], Int) = this match {
    case Leaf(n) => (Leaf((n, seed)), seed+1)
    case Branch(l, r) => {
      val (lt, seed1) = l.number(seed)
      val (rt, seed2) = r.number(seed1)
      (Branch(lt, rt), seed2)
  }
*/

  private static void stateTrial() {
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

  public static void main(String[] args) {    
    Tree<Integer> empty = new Tree.Empty<Integer>();
    Tree<Integer> leaf1 = new Tree.Leaf<Integer>(1);
    Tree<Integer> leaf2 = new Tree.Leaf<Integer>(2);
    Tree<Integer> leaf3 = new Tree.Leaf<Integer>(3);
    Tree<Integer> leaf4 = new Tree.Leaf<Integer>(4);
    Tree<Integer> leaf5 = new Tree.Leaf<Integer>(5);
    Tree<Integer> leaf6 = new Tree.Leaf<Integer>(6);
    Tree<Integer> leaf7 = new Tree.Leaf<Integer>(7);
    Tree<Integer> leaf8 = new Tree.Leaf<Integer>(8);
    Tree<Integer> leaf9 = new Tree.Leaf<Integer>(9);

    Tree<Integer> t1 = new Tree.Branch<Integer>(new Tree.Branch<Integer>(leaf2, leaf6), leaf9);
    Tree<Integer> t2 = new Tree.Branch<Integer>(new Tree.Branch<Integer>(leaf2, new Tree.Branch<Integer>(leaf4, leaf5)), leaf9);

    println("depth of empty tree = " + depth(empty));
    println("depth of leaf tree = " + depth(leaf1));
    println("depth of empty branch tree = " + depth(new Tree.Branch<Integer>(empty, empty)));
    println("depth of t1 " + depth(t1));
    println("depth of t2 " + depth(t2));

    stateTrial();
  }

}
