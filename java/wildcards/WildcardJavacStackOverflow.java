//
// Compiling this causes javac to have a stack-overflow.
//
// Found at http://relation.to/Bloggers/FunWildcardrelatedProblemInJavasTypesystem
//

interface Interface<T> {}

class Bang<T> implements Interface<Interface<? super Bang<Bang<T>>>> {
  static void bang() {
    Interface<? super Bang<Byte>> bang = new Bang<Byte>();
  }
}
