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
    if(ma instanceof Maybe) {
      final A j = ((Maybe<A>)ma).just();
      if (j == null) {
        return new Maybe<B>();
      } else {
        final Monad<B> b = f.f(j);

        if(b instanceof Maybe) {
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
}
