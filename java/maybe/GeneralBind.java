//
// Adapted from https://docs.google.com/View?docid=dx5mfkq_17fnd4ss&pli=1
//   which is linked from http://blog.tmorris.net/strong-type-systems/ by Ricky Clarkson.
//

interface Function<A, B> {
  B run(A a);
}

interface Monad<A> {
  <B> Monad<B> bind(Function<A,B> function);
}

interface Maybe<A> extends Monad<A> {
}

final class Just<A> implements Maybe<A> {
  private final A a;

  public Just(A a) {
    this.a = a;
  }

  public <B> Maybe<B> bind(Function<A, B> function) {
    return new Just<B>(function.run(a));
  }
}

final class Nothing<A> implements Maybe<A> {
  public <B> Maybe<B> bind(Function<A, B> function) {
    return new Nothing<B>();
  }
}
