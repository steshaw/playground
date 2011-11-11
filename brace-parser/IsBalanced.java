//
// 1. Fixed so it iterates on args.
// 2. Fixed unchecked warning.
// 3. Fixed bug - missing 'else return false'
//

import java.util.ArrayList;
 
public class IsBalanced {
 
  private Stack stack = new Stack();
 
  public boolean isBalanced(String expression) {
 
    boolean isBalanced = true;
 
    for (int i = 0; i < expression.length(); i++) {
      char nextChar = expression.charAt(i);
 
      if (nextChar == '(') {
        stack.push('(');
      }
      else if (nextChar == '[') {
        stack.push('[');
      } else {
        if (!stack.isEmpty()) {
          char stackChar = (Character) stack.peek();
          if (nextChar == ')') {
            if (stackChar == '(') {
              stack.pop();
            } else {
              return false;
            }
 
          } else if (nextChar == ']') {
            if (stackChar == '[') {
              stack.pop();
            } else {
               return false;
            }
          } else {
            return false;
          }
        } else {
          return false;
        }
      }
    }
 
    if (!stack.isEmpty()) {
      isBalanced = false;
    }
    return isBalanced;
  }
 
  public static void main(String[] args) {
    for (String arg : args) {
      System.out.println(new IsBalanced().isBalanced(arg));
    }
  }
 
  private class Stack {
 
    private ArrayList<Character> stack = new ArrayList<Character>();
 
    public void push(char c) {
      stack.add(c);
 
    }
 
    public void pop() {
      stack.remove(stack.size()-1);
    }
 
 
    public Object peek() {
      return stack.get(stack.size()-1);
    }
 
    public boolean isEmpty() {
      return stack.size() == 0;
    }
  }
}
