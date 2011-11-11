public class SimpleBraceParser {

  private int index = 0;
  private String s;

  public SimpleBraceParser(String s) { this.s = s; }

  private void skip(char c) {
    ++index;
  }

  private char currentChar() {
    if (index < s.length()) return s.charAt(index);
    else return '\000'; // Evil "sentinel" value
  }

  private void eat(char c) {
    if (currentChar() == c) {
      ++index;
      return;
    }
    throw new RuntimeException("parse error at " + index + ", expecting '" + c + "'");
  }

  public void parseRoundBrace() {
    skip('(');
    parseExpr();
    eat(')');
  }

  public void parseSquareBracket() {
    skip('[');
    parseExpr();
    eat(']');
  }

  public boolean parseExpr() {
    if (currentChar() == '(') {
      parseRoundBrace();
      return true;
    } else if (currentChar() == '[') {
      parseSquareBracket();
      return true;
    } else return false;
  }

  public void parseExprs() {
    while (parseExpr()) {
    }
  }

  public void parse() {
    parseExprs();
    if (currentChar() != '\000')
      throw new RuntimeException("not terminated correctly at " + index);
  }

  static boolean reportErrors = false;

  public static void main(String[] args) {
    for (String arg : args) {
      SimpleBraceParser p = new SimpleBraceParser(arg);
      try {
        p.parse();
        System.out.println("true");
      } catch (Exception e) {
        if (reportErrors) e.printStackTrace(System.err);
        System.out.println("false");
      }
    }
  }

}
