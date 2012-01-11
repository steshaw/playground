//
// See http://cseweb.ucsd.edu/~rtate/publications/tamewild/
//

import java.util.List;

class Reflection {
  <P> void addSuperclasses(Class<P> c, List<? super Class<? super P>> list) {
    Class<? super P> sup = c.getSuperclass();
    if (sup != null) {
      list.add(sup);
      addSuperclasses(sup, list);
    }
  }
}
