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
}

class Person {
  final String name;
  final int age;

  Person(String name, int age) {
    this.name = name;
    this.age = age;
  }

  @Override public String toString() {
    return "Person(name = '" + name + "' age = " + age + ")";
  }

  static Person mk(String name, int age) {
    return new Person(name, age);
  }
}

class Main {
  static Maybe<String> couldBeName() {
    return new Maybe<String>("Steve");
  }

  static Maybe<Integer> couldBeAge() {
    return new Maybe<Integer>(40);
  }

  static Maybe<Person> couldBePerson(Maybe<String> maybeName, Maybe<Integer> maybeAge) {
    return maybeName.bind(/* XXX - why is this param required? */ (Monad<String>)maybeName, new F<String, Monad<Person>>() {
      @Override public Monad<Person> f(String name) {
        System.out.println("a1 - name = " + name);
        return (Monad<Person>) new Maybe<Person>(Person.mk(name, 40));
      }
    });
  }

  public static void main(String[] args) {
    System.out.println(couldBePerson(couldBeName(), couldBeAge()));
  }
}
