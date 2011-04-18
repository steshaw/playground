//
// TreeWalker listing from disappointing article http://java.sys-con.com/node/574653/print
//

interface Aggregator {
  public Object initialValue ();
  public Object combine (Object x, Object y);
}

public class TreeWalker {

  public Object aggregate (Object[] tree, Aggregator a) {

    Object o = a.initialValue();
    for (Object item : tree) {
      if (item instanceof Object[]) {
        o = a.combine(o, aggregate((Object[])item, a));
      } else {
        o = a.combine(o, item);
      }
    }
    return o;
  }
}

class Main {

  public static void main(String[] args) {

    Object[] myTree =
      new Object [] { 4,
          7,
          new Object[] {3, 8},
          new Object[] {2, new Object[] { 5, 9 }},
          6 };

    TreeWalker treeWalker = new TreeWalker();

    Object sum = treeWalker.aggregate(myTree, new Aggregator() {
      public Object initialValue() { return 0; }
      public Object combine(Object x, Object y) {
        return ((Integer)x).intValue() + ((Integer)y).intValue();
      } });
    System.out.println ("Sum is " + sum);
    
    Object product = treeWalker.aggregate(myTree, new Aggregator() {
      public Object initialValue() { return 1; }
      public Object combine(Object x, Object y) {
        return ((Integer)x).intValue() * ((Integer)y).intValue();
      } });
    System.out.println ("Product is " + product);
  }

}
