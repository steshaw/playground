//
// Adapted from https://docs.google.com/View?docid=dx5mfkq_17fnd4ss&pli=1
//   which is linked from http://blog.tmorris.net/strong-type-systems/ by Ricky Clarkson.
//
// 1. Changed the signature of bind (which looked a lot like map).
//

interface Function<A, B> {
  B run(A a);
}

interface Monad<A> {
  // This original bind method has the wrong signature. It looks more like map.
//  <B> Monad<B> bind(Function<A, B> function);

  //
  // Here we try to fix it.
  //
  // Should be like this Haskell signature:
  //   (>>=) :: (Monad m) => m a -> (a -> m b) -> m b
  //
  <B> Monad<B> bind(Function<A, Monad<B>> function);
}

interface Maybe<A> extends Monad<A> {
}

final class Just<A> implements Maybe<A> {
  private final A a;

  public Just(A a) {
    this.a = a;
  }

  public <B> Monad<B> bind(Function<A, Monad<B>> function) {
    return function.run(a);
  }

  @Override public String toString() {
    return "Just " + a.toString();
  }

  static <B> Just<B> just(B b) {
    return new Just<B>(b);
  }
}

final class Nothing<A> implements Maybe<A> {
  public <B> Monad<B> bind(Function<A, Monad<B>> function) {
    return nothing();
  }
  @Override public String toString() {
    return "Nothing";
  }
  static <B> Nothing<B> nothing() {
    return new Nothing<B>();
  }
}

class Person {
  final String name;
  final int age;

  Person(final String name, final int age) {
    this.name = name;
    this.age = age;
  }

  @Override public String toString() {
    return "Person(name = '" + name + "' age = " + age + ")";
  }

  static Person mk(final String name, final int age) {
    return new Person(name, age);
  }
}

class GeneralBindDemo {
  static Maybe<Person> couldBePerson(final Maybe<String> maybeName, final Maybe<Integer> maybeAge) {
    return (Maybe<Person>) maybeName.bind(new Function<String, Monad<Person>>() {
      @Override public Monad<Person> run(final String name) {
        return maybeAge.bind(new Function<Integer, Monad<Person>>() {
          @Override public Monad<Person> run(final Integer age) {
            return Just.just(Person.mk(name, age));
          }
        });
      }
    });
  }

  static void println(Object msg) {
    System.out.println(msg.toString());
  }

  public static void main(final String[] args) {
    println(couldBePerson(Just.just("Fred"), Just.just(25)));
    println(couldBePerson(Nothing.<String>nothing(), Just.just(25)));
    println(couldBePerson(Just.just("Fred"), Nothing.<Integer>nothing()));
    println(couldBePerson(Nothing.<String>nothing(), Nothing.<Integer>nothing()));
  }
}
