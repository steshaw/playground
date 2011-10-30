//
// Another approach to implementing Maybe.
//

interface F<X, Y> {
  Y f(X x);
}

// No longer implemented. Just here for "documentation".
interface Monad<A> {
  <B> Monad<B> bind(F<A, Monad<B>> f);
}

// Maybe utilties - just bind for now
abstract class MaybeU {
  public static <A, B> Maybe<B> bind(final Maybe<A> a, final F<A, Maybe<B>> f) {
    if (a.isNothing()) {
      return Maybe.<B>nothing();
    } else {
      return f.f(a.just());
    }
  }
}

abstract class Maybe<A> {
  private Maybe() {}

  abstract boolean isJust();
  abstract boolean isNothing();
  abstract A just();

  static <A> Maybe<A> just(final A a) {
    return new Maybe<A>() {
      boolean isJust() { return true; }
      boolean isNothing() { return false; }
      A just() {return a; }
      @Override public String toString() { return "Just " + a; }
    };
  }

  static <A> Maybe<A> nothing() {
    return new Maybe<A>() {
      boolean isJust() { return false; }
      boolean isNothing() { return true; }
      A just() {throw new IllegalStateException("cannot just on a Nothing"); }
      @Override public String toString() { return "Nothing"; }
    };
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

class AnotherApproachDemo {
  static Maybe<Person> couldBePerson(final Maybe<String> maybeName, final Maybe<Integer> maybeAge) {
    return MaybeU.bind(maybeName, new F<String, Maybe<Person>>() {
      @Override public Maybe<Person> f(final String name) {
        return MaybeU.bind(maybeAge, new F<Integer, Maybe<Person>>() {
          @Override public Maybe<Person> f(final Integer age) {
            return Maybe.just(Person.mk(name, age));
          }
        });
      }
    });
  }

  static void println(Object msg) {
    System.out.println(msg.toString());
  }

  public static void main(final String[] args) {
    println(couldBePerson(Maybe.just("Fred"), Maybe.just(25)));
    println(couldBePerson(Maybe.<String>nothing(), Maybe.just(25)));
    println(couldBePerson(Maybe.just("Fred"), Maybe.<Integer>nothing()));
    println(couldBePerson(Maybe.<String>nothing(), Maybe.<Integer>nothing()));
  }
}
