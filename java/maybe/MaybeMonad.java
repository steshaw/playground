//
// Adapted from http://blog.tmorris.net/strong-type-systems/
//

interface F<A, B> {
  B apply(A a);
}

interface Monad<A> {
  // (>>=) :: (Monad m) => m a -> (a -> m b) -> m b
  <B> Monad<B> bind(Monad<A> ma, F<A, Monad<B>> f);
}

interface Monad<A> {
  <B> Monad<B> bind(Function<A,B> function);
}

// Original non-compiling code from article.
/*
final class Maybe<A> implements Monad<A> {
  // BZZT! WRONG!
  Maybe<A> bind(final Maybe<A> ma, final F<A, Maybe<B>> f) {
  }
}
*/

// Slightly modified but still non-compiling code.
/*
final class Maybe2<A> implements Monad<A> {
  <B> Maybe2<B> bind(final Maybe2<A> ma, final F<A, Maybe2<B>> f) {
    // ...
  }
}
*/
