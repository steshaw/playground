//
// Originally from http://c2.com/cgi/wiki?StringTrie
//

import java.util.*;

/*
 * Note: To avoid the case that an entire string is a prefix of another one, each
 * key is appended by "\0"
 */

/* Implement compressed trie tree data structure. */
public class Trie {
                  /* Define the object that indicates no such key was found. */
                  public static final Object NO_SUCH_KEY = "Object:NO_SUCH_KEY";

                  /* Represent data stored in each node */
                  private class TrieItem implements Comparable<TrieItem> {
                                      public int
                                       index,	/* The index among 'strings' list */
                                       begin,	/* The begin of the substring */
                                       end;	/* The end of the substring */

                                      /* The reference to the list of strings used in
                                                          tries */
                                      private List<String> strings;

                                      /* Data associated this keyword that
                                                          ends at this item. */
                                      public Object element;

                                      /* Constructor */
                                      TrieItem (int index, int begin, int end,
                                       List<String> strings, Object element) {
                                                          this.index = index;
                                                          this.begin = begin;
                                                          this.end = end;
                                                          this.strings = strings;
                                                          this.element = element;
                                      }

                                      /* Return the substring that this item represents. */
                                      public String getString () {
                                                          return strings.get(index).substring (begin, end + 1);
                                      }

                                      /* For debugging purpose */
                                      public String toString () {
                                                          return getString() + ":" + index + "," + begin + "," + end;
                                      }

                                      /* Implement comparable interface */
                                      public int compareTo (TrieItem o) {
                                                          return getString().compareTo (o.getString());
                                      }

                                      /* Make sure equals method consistent with compareTo method */
                                      public boolean equals (Object o) {
                                                          return o instanceof TrieItem && compareTo (o) == 0;
                                      }
                  }

                  /* The number of keywords stored in trie */
                  private int m_size;

                  /* The list of strings stored in trie */
                  private List<String> m_strings;

                  /* The root node of the trie tree */
                  private Node m_head;

                  /* Constructor */
                  Trie () {
                                      m_strings = new ArrayList<String> ();
                                      m_head = new Node (null);	/* There is always a root that has null element. */
                                      m_size = 0;
                  }

                  /* Return the number of items */
                  public int size () { return m_size; }

                  /* Test if this is empty */
                  public boolean isEmpty () {
                                      return size () == 0;
                  }

                  /* Find the longest node corresponding to key */
                  private Node find (Node node, String key) {
                                      for (Iterator<Node> i = node.children (); i.hasNext (); ) {
                                                          /* Try a new lineage */
                                                          Node candidate = i.next ();
                                                          String s = ((TrieItem) candidate.element).getString ();
                                                          if (key.startsWith (s)) {
                                                                              key = key.substring (s.length ());
                                                                              if (key.length () > 0) {
                                                                                                  /* Seek this lineage. */
                                                                                                  return find (candidate, key);
                                                                              }
                                                                              else {
                                                                                                  /* This lineage matches. */
                                                                                                  return candidate;
                                                                              }
                                                          }
                                      }

                                      /* This doesn't match */
                                      return null;
                  }

                  /* If this contains an item with key equal to k, then return the element of such an item,
                                      else return null */
                  public Object findElement (String key) {
                                      key += "\0";

                                      Node node = find (m_head, key);
                                      if (node != null)
                                                          return ((TrieItem) node.element).element;
                                      else
                                                          return NO_SUCH_KEY;
                  }

                  /* Insert an item with element and key */
                  public void insertItem (String key, Object element) {
                                      key += "\0";

                                      /* Make sure there is no corresponding key now. */
                                      if (findElement (key) != NO_SUCH_KEY)
                                                          return;

                                      /* Add new string */
                                      m_strings.add (key);
                                      final int index = m_strings.size () - 1;

                                      Node node = m_head;

                                      for (int i = 0; i < key.length (); i++) {
                                                          final TrieItem item = new TrieItem (index, i, i, m_strings, null);

                                                          /* Find the child corresponding to a character. */
                                                          Node next = node.getChild (item);
                                                          if (next == null) {
                                                                              /* If not found, add new one. */
                                                                              next = new Node (item);
                                                                              node.add (next);
                                                          }

                                                          node = next;
                                      }

                                      /* Put element at the last node of the lineage */
                                      ((TrieItem) node.element).element = element;
                  }

                  /* Compress the subtree that the given node leads. Return the new subtree. */
                  private Node compress0 (Node node) {
                                      if (node.size () == 1) {
                                                          /* The node can be compressed. */

                                                          /*
                                                           * First, get the compressed the subtree. Be careful, most of time, it
                                                           * is one node, possibly is a subtree.
                                                           */
                                                          Node new_node = compress0 (node.children ().next ());

                                                          /*
                                                           * Note: Be careful. Don't expand the string of the node
                                                           * but the string of the node's child.
                                                           */
                                                          TrieItem child = (TrieItem) new_node.element;
                                                          assert child.begin > 0;
                                                          --child.begin;

                                                          return new_node;
                                      }
                                      else
                                      {
                                                          /* The node cannot be compressed. */

                                                          /* Aggregate the compressed new children */
                                                          Node new_node = new Node (node.element);
                                                          for (Iterator<Node> i = node.children (); i.hasNext (); ) {
                                                                              new_node.add (compress0 (i.next ()));
                                                          }

                                                          return new_node;
                                      }
                  }

                  /* Compress the trie tree */
                  public void compress () {
                                      /* Aggregate the compressed new children */
                                      Node new_head = new Node (null);
                                      for (Iterator<Node> i = m_head.children (); i.hasNext (); ) {
                                                          new_head.add (compress0 (i.next ()));
                                      }

                                      m_head = new_head;
                  }

                  /* For debugging purpose. Add up debug info of the ancestors of
                                      the node. */
                  private String ancestryToString (Node node, int indent) {
                                      String s = "";

                                      for (int i = 0; i < indent; i++)
                                                          s += " ";

                                      TrieItem item = (TrieItem) node.element;
                                      s += item + "\n";

                                      for (Iterator<Node> i = node.children (); i.hasNext (); ) {
                                                          s += ancestryToString (i.next (), indent + 1);
                                      }

                                      return s;
                  }

                  /* For debugging purpose. */
                  public String toString () {
                                      String s = "";

                                      for (String x : m_strings) {
                                                          s += x + "\n";
                                      }

                                      for (Iterator<Node> i = m_head.children (); i.hasNext (); ) {
                                                          s += ancestryToString (i.next (), 0);
                                      }

                                      return s;
                  }
}
