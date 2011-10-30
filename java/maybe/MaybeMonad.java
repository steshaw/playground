//
// Adapted from http://blog.tmorris.net/strong-type-systems/
//
class MaybeMonad {

  interface F<A, B> {
    B apply(A a);
  }

  interface Monad<A> {
    // (>>=) :: (Monad m) => m a -> (a -> m b) -> m b
    <B> Monad<B> bind(Monad<A> ma, F<A, Monad<B>> f);
  }
}
