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

  public static void main(String[] args) {
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
