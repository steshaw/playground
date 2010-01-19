//
// See http://blog.tmorris.net/dear-java-guy-state-is-a-monad/
//

class StateMonadExample {

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
          return "(" + a + ", " + b + ")";
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

  public static void main(String[] args) {
    State<Integer, String> state0 = new State<Integer, String>() {
      public Pair<Integer, String> run(Integer s) {
        return Pairs.pair(s, "Initial");
      }
    };
    System.out.println("initial state = " + state0.run(100));
    State<Integer, String> state1 = States.map(state0, new Function<String, String>() {
      public String apply(String x) {
        return x + ".";
      }
    });
    System.out.println("state = " + state1.run(100));
  }

}
