// A list that is either empty or has one element.
public abstract class NoneOrOne<A> {
  // The key abstract method (catamorphism).
  public abstract <X> X fold(Thunk<X> none, Func<A, X> one);
 
  // Produces an empty list.
  public static <A> NoneOrOne<A> none() {
    throw new Error("todo");
  }
 
  // Produces a list with the given element.
  public static <A> NoneOrOne<A> one(final A a) {
    throw new Error("todo");
  }
 
  // Returns true if this list is empty.
  public boolean isEmpty() {
    throw new Error("todo");
  }
 
  // Maps the given function on each element of this list.
  public <B> NoneOrOne<B> map(final Func<A, B> f) {
    throw new Error("todo");
  }
 
  // Filters the list on the given predicate.
  // The element is retained if the predicate satisfies.
  public NoneOrOne<A> filter(final Func<A, Boolean> p) {
    throw new Error("todo");
  }
 
  // Applies the possible function on this list.
  public <B> NoneOrOne<B> app(final NoneOrOne<Func<A, B>> f) {
    throw new Error("todo");
  }
 
  // Binds the given function on this list.
  public <B> NoneOrOne<B> bind(final Func<A, NoneOrOne<B>> f) {
    throw new Error("todo");
  }
 
  // Returns the value held in this list.
  // However, if it is empty, return the given default value.
  public A get(final Thunk<A> def) {
    throw new Error("todo");
  }
 
  // If this list is empty, return the given one.
  // Otherwise, return this list.
  public NoneOrOne<A> orElse(final NoneOrOne<A> els) {
    throw new Error("todo");
  }
 
  // For debugging
  public String toString() {
    final StringBuilder s = new StringBuilder();
    s.append('[');
    fold(new Thunk<Object>() {
      public Object value() {
        return null; // Java has no suitable unit type.
      }
    }, new Func<A, Object>() {
      public Object apply(final A a) {
        s.append(a);
        return null; // Java has no suitable unit type.
      }
    });
    return s.append(']').toString();
  }
 
  // TEST
  public static void main(final String[] args) {
    final NoneOrOne<Integer> s = NoneOrOne.one(Integer.parseInt(args[0]));
 
    final NoneOrOne<String> t = s.map(new Func<Integer, String>() {
      public String apply(final Integer i) {
        return new StringBuilder(Integer.valueOf(i * 123).toString()).reverse().toString();
      }
    });
 
    final NoneOrOne<Integer> u = s.filter(new Func<Integer, Boolean>() {
      public Boolean apply(final Integer i) {
        return i < 100;
      }
    });
 
    final NoneOrOne<String> v = s.app(NoneOrOne.<Func<Integer, String>>one(
      new Func<Integer, String>() {
      public String apply(final Integer i) {
        return String.valueOf(Math.pow(i, i));
      }
    }));
 
    final NoneOrOne<String> w = s.bind(new Func<Integer, NoneOrOne<String>>() {
      public NoneOrOne<String> apply(final Integer i) {
        return i % 2 == 0 ?
          one("it's even") :
          i % 3 == 0 ?
            one("it's divisible by 3 but not 6") :
            NoneOrOne.<String>none();
      }
    });
 
    final Integer x = s.get(new Thunk<Integer>() {
      public Integer value() {
        return 42;
      }
    });
 
    final NoneOrOne<Integer> y = NoneOrOne.<Integer>none().orElse(s);
 
    /*
    $ java NoneOrOne 122
    [122]
    [60051]
    []
    [3.4347832971354663E254]
    [it's even]
    122
    [122]
 
    $ java -classpath /tmp/ NoneOrOne 12
    [12]
    [6741]
    [12]
    [8.916100448256E12]
    [it's even]
    12
    [12]
    */
    System.out.println(s);
    System.out.println(t);
    System.out.println(u);
    System.out.println(v);
    System.out.println(w);
    System.out.println(x);
    System.out.println(y);
  }
}
 
// Laziness
interface Thunk<T> {
  T value();
}
 
// Takes an A and produces a B
interface Func<A, B> {
  B apply(A a);
}
