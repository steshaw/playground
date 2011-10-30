//
// Adapted from https://docs.google.com/View?docid=dx5mfkq_17fnd4ss&pli=1
//   which is linked from http://blog.tmorris.net/strong-type-systems/ by Ricky Clarkson.
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
}

final class Nothing<A> implements Maybe<A> {
  public <B> Monad<B> bind(Function<A, Monad<B>> function) {
    return new Nothing<B>();
  }
  @Override public String toString() {
    return "Nothing";
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

class GeneralBindDemo {
  // TODO: bind on maybeAge
  static Maybe<Person> couldBePerson(Maybe<String> maybeName, Maybe<Integer> maybeAge) {
    Monad<Person> result = maybeName.bind(new Function<String, Monad<Person>>() {
      @Override public Maybe<Person> run(String name) {
        return new Just<Person>(Person.mk(name, 3));
      }
    });
    return (Maybe<Person>)result;
  }

  public static void main(String[] args) {
    System.out.println(couldBePerson(new Just<String>("Fred"), new Just<Integer>(25)));
  }
}
