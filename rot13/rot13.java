//
// From http://www.miranda.org/~jkominek/rot13/java/
//

import java.io.*;

public class rot13 {
  public static void main (String args[]) {
    int abyte = 0;
    try { while((abyte = System.in.read())>=0) {
      int cap = abyte & 32;
      abyte &= ~cap;
      abyte = ((abyte >= 'A') && (abyte <= 'Z') ? ((abyte - 'A' + 13) % 26 + 'A') : abyte) | cap;
      System.out.print(String.valueOf((char)abyte));
    } } catch (IOException e) { }
    System.out.flush();
  }
}
