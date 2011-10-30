//
// Adapted from the "compilable solution" from the end of the post http://blog.tmorris.net/strong-type-systems/
//
// 1. Deleted the unnecessary first argument to bind as it was the same as the implicit receiver.
// 2. No longer implement Monad as it's not possible to have the correct type for bind (I guess
//    that's the point of the post).
//

interface F<X, Y> {
  Y f(X x);
}

/*
interface Monad<A> {
  <B> Monad<B> bind(F<A, Monad<B>> f);
}
*/

final class Maybe<A> /*implements Monad<A>*/ {
  public <B> Maybe<B> bind(final F<A, Maybe<B>> f) {
    final A a = just();
    if (isNothing()) {
      return Maybe.<B>nothing();
    } else {
      return f.f(a);
    }
  }

  // Let's just hack for now.
  // null denotes 'Nothing'.
  // Many programmers will be familiar
  // with this idiom (did I say hack?)
  // anyway.
  //
  // A more complete solution is provided at
  // http://blog.tmorris.net/revisiting-maybe-in-java
  private final A a;

  public Maybe() {
    this.a = null;
  }

  public Maybe(final A a) {
    this.a = a;
  }

  public A just() {
    return a;
  }

  public boolean isNothing() {
    return a == null;
  }

  @Override public String toString() {
    return isNothing()? "Nothing" : "Just " + a.toString();
  }

  static <A> Maybe<A> just(final A a) {
    return new Maybe<A>(a);
  }
  static <A> Maybe<A> nothing() {
    return new Maybe<A>();
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

class Demo {
  static Maybe<Person> couldBePerson(final Maybe<String> maybeName, final Maybe<Integer> maybeAge) {
    return maybeName.bind(new F<String, Maybe<Person>>() {
      @Override public Maybe<Person> f(final String name) {
        return maybeAge.bind(new F<Integer, Maybe<Person>>() {
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
