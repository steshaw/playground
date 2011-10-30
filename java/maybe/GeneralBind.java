//
// Adapted from https://docs.google.com/View?docid=dx5mfkq_17fnd4ss&pli=1
//   which is linked from http://blog.tmorris.net/strong-type-systems/ by Ricky Clarkson.
//
// 1. Changed the signature of bind (which looked a lot like map).
//
//      <B> Monad<B> bind(Function<A, B> function)
//
// 2. No longer implement Monad in order to have correct signature for bind.
//

interface Function<A, B> {
  B run(A a);
}

// No longer used.
interface Monad<A> {
  <B> Monad<B> bind(Function<A, Monad<B>> function);
}

interface Maybe<A> /*extends Monad<A>*/ {
  <B> Maybe<B> bind(Function<A, Maybe<B>> function);
}

final class Just<A> implements Maybe<A> {
  private final A a;

  public Just(A a) {
    this.a = a;
  }

  public <B> Maybe<B> bind(Function<A, Maybe<B>> function) {
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
  public <B> Maybe<B> bind(Function<A, Maybe<B>> function) {
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
    return maybeName.bind(new Function<String, Maybe<Person>>() {
      @Override public Maybe<Person> run(final String name) {
        return maybeAge.bind(new Function<Integer, Maybe<Person>>() {
          @Override public Maybe<Person> run(final Integer age) {
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
