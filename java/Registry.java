//
// From "Effective Java Reloaded" presentation slides.
//

import java.util.Map;
import java.util.HashMap;

public class Registry {
  private Map<Class<?>, Object> favorites = new HashMap<Class<?>, Object>();

  public <T> void setFavorite(Class<T> klass, T thing) {
    favorites.put(klass, thing);
  }

  public <T> T getFavorite(Class<T> klass) {
    return klass.cast(favorites.get(klass));
  }

  public static void main(String[] args) {
    Registry f = new Registry();
    f.setFavorite(String.class, "Java");
    f.setFavorite(Integer.class, 0xcafebabe);
    String s = f.getFavorite(String.class);
    int i = f.getFavorite(Integer.class);
  }
}
