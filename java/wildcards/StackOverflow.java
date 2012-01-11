//
// See http://cseweb.ucsd.edu/~rtate/publications/tamewild/
//

class D<T> {}
class L<T> {}
class C<P> extends D<D<? super C<L<P>>>> {}

class Demo {
  <X> void oops(X x) {
    D<? super C<X>> a = new C<X>(); // Stack overflow!
  }
}
