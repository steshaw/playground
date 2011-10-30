//
// The "compilable solution" from the end of the post http://blog.tmorris.net/strong-type-systems/
//

interface F<X, Y> {
  Y f(X x);
}

interface Monad<A> {
  <B> Monad<B> bind(Monad<A> ma, F<A, Monad<B>> f);
}

final class Maybe<A> implements Monad<A> {
  public <B> Maybe<B> bind(final Monad<A> ma, final F<A, Monad<B>> f) {
    if (ma instanceof Maybe) {
      final A j = ((Maybe<A>)ma).just();
      if (j == null) {
        return new Maybe<B>();
      } else {
        final Monad<B> b = f.f(j);

        if (b instanceof Maybe) {
          return (Maybe<B>)b;
        } else {
          throw new Error("Just because we don't have higher-order types," +
            "doesn't mean we start doing silly stuff");
        }
      }
    } else {
      throw new Error("I said stop doing silly stuff! Please!");
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

  @Override public String toString() {
    if (a == null) return "Nothing"; else return "Just " + a.toString();
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
    return maybeName.bind(/* XXX - why is this param required? */ (Monad<String>)maybeName, new F<String, Monad<Person>>() {
      @Override public Monad<Person> f(final String name) {
        return maybeAge.bind(/*XXX*/maybeAge, new F<Integer, Monad<Person>>() {
          @Override public Monad<Person> f(final Integer age) {
            return (Monad<Person>) Maybe.just(Person.mk(name, age));
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
