//
// See http://docs.oracle.com/javase/tutorial/extra/generics/wildcards.html
//
import java.util.*;
class CompileTimeError {
  static {
    Collection<?> c = new ArrayList<String>();
    c.add(new Object()); // Compile time error
  }
}
