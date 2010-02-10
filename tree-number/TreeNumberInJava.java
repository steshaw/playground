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
    public static <A> Tree.Leaf<A> leaf(A a) {
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
          // Output like in Scala.
          return "(" + a + "," + b + ")";
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

  // XXX: This does not work. Type-check fails in use.
  static <A, B> F<? extends Tree<A>, B> constant(final B b) {
    return new F<Tree<A>, B>() {
      public B f(Tree<A> ignore) { return b; };
    };
  }

  // XXX: This cannot be used either due to type-check failure.
  private static <A> F<? extends Tree<A>, Integer> zeroOnEmpty() {
    return new F<Tree.Empty<A>, Integer>() {
      public Integer f(Tree.Empty<A> tree) {
        return 0;
      }
    };
  }

  // XXX: ditto here :(
  private static <A> F<? extends Tree<A>, Integer> oneOnLeaf() {
      return new F<Tree.Leaf<A>, Integer>() {
        public Integer f(Tree.Leaf tree) {
          return 1;
        }
      };
  }

  public static <A> int depth(Tree<A> t) {
    // XXX: Type-check fails in use of constant(n)
//    return t.match(constant(0), constant(1), new F<Tree.Branch<A>, Integer>(){
//      public Integer f(Tree.Branch<A> n) {
//        return 1 + max(depth(n.left), depth(n.right));
//      }
//    });

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

  static void println(String s) {
    System.out.println(s);
  }
  static void print(String s) {
    System.out.print(s);
  }
  static void println() {
    System.out.println();
  }

/*
  // Scala version of tree-numbering for reference.
  public static number(seed: Int): (Tree[(A, Int)], Int) = this match {
    case Leaf(n) => (Leaf((n, seed)), seed+1)
    case Branch(l, r) => {
      val (lt, seed1) = l.number(seed)
      val (rt, seed2) = r.number(seed1)
      (Branch(lt, rt), seed2)
  }
*/
  // "Simple" non-state monad version of tree numbering.
  public static <A> Pair<? extends Tree<Pair<A, Integer>>, Integer> number(Tree<A> t, final int seed) {
    return t.match(new F<Tree.Empty<A>, Pair<? extends Tree<Pair<A, Integer>>, Integer>>() {
      public Pair<? extends Tree<Pair<A, Integer>>, Integer> f(Tree.Empty<A> t) {
          //return Pairs.pair(Trees.empty(), seed);
        return Pairs.pair(new Tree.Empty<Pair<A, Integer>>(), seed);
      }
    }, new F<Tree.Leaf<A>, Pair<? extends Tree<Pair<A, Integer>>, Integer>>() {
      public Pair<? extends Tree<Pair<A, Integer>>, Integer> f(Tree.Leaf<A> t) {
          return Pairs.pair(Trees.leaf(Pairs.pair(t.a, seed)), seed+1);
      }
    }, new F<Tree.Branch<A>, Pair<? extends Tree<Pair<A, Integer>>, Integer>>() {
      public Pair<? extends Tree<Pair<A, Integer>>, Integer> f(Tree.Branch<A> t) {
        Pair<? extends Tree<Pair<A, Integer>>, Integer> lp = number(t.left, seed);
        Pair<? extends Tree<Pair<A, Integer>>, Integer> rp = number(t.right, lp.second());
        return Pairs.pair(Trees.branch(lp.first(), rp.first()), rp.second());
      }
    });
  }

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

  final static class Unit {
    private Unit() {}
    static Unit value = new Unit();
  };

  public static <A> void printTree(Tree<A> t) {
    t.match(new F<Tree.Empty<A>, Unit>() {
      public Unit f(Tree.Empty<A> t) {
        print("Empty()");
        return Unit.value;
      }
    }, new F<Tree.Leaf<A>, Unit>() {
      public Unit f(Tree.Leaf<A> t) {
        print("Leaf(" + t.a + ")");
          return Unit.value;
      }
    }, new F<Tree.Branch<A>, Unit>() {
      public Unit f(Tree.Branch<A> t) {
        print("Branch(");
        printTree(t.left);
        print(",");
        printTree(t.right);
        print(")");
        return Unit.value;
      }
    });
  }

  public static void go(Tree<Integer> t) {
    printTree(t);
    println();
    printTree(number(t, 10).first());
    println();
  }

  public static void main(String[] args) {    
    Tree<Integer> empty = Trees.empty();
    Tree<Integer> leaf1 = Trees.leaf(1);
    Tree<Integer> leaf2 = Trees.leaf(2);
    Tree<Integer> leaf4 = Trees.leaf(4);
    Tree<Integer> leaf5 = Trees.leaf(5);
    Tree<Integer> leaf6 = Trees.leaf(6);
    Tree<Integer> leaf9 = Trees.leaf(9);

    Tree<Integer> t1 = Trees.branch(Trees.branch(leaf2, leaf6), leaf9);
    Tree<Integer> t2 = Trees.branch(Trees.branch(leaf2, Trees.branch(leaf4, leaf5)), leaf9);

    // Since we only have one algorithm, just run the same one twice with a line in between to match the "expected" file.
    go(t1);
    go(t2);
    println();

    go(t1);
    go(t2);

    boolean justDoTreeNumbering = false;
    if (justDoTreeNumbering) {
      println("depth of empty tree = " + depth(empty));
      println("depth of leaf tree = " + depth(leaf1));
      println("depth of empty branch tree = " + depth(new Tree.Branch<Integer>(empty, empty)));
      println("depth of t1 " + depth(t1));
      println("depth of t2 " + depth(t2));

      stateTrial();
    }
  }

}
