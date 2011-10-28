class StringEqualable implements Equalable<String> {
  public boolean equalTo(String s1, String s2) {
    return s1.equals(s2); // delegate to equals here...
  }
}
