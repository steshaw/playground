//
// Inspired by http://ceylon-lang.org/blog/2011/12/08/let-it-work/
//
class Counter{
  long n;
  long getN(){
    return n;
  }
  void setN(long n){
    this.n = n;
  }
}
class PlusPlus {
  Counter c = new Counter();
  long plusPlus() {
    long n = new Object(){
        long postIncrement(Counter c){
            long previousValue = c.getN();
            c.setN(previousValue+1);
            return previousValue;
        }
    }.postIncrement(c);
    return n;
  }
  public static void tryPlusPlus(PlusPlus plusPlus) {
    System.out.println("++");
    long n = plusPlus.plusPlus();
    System.out.println("c.n = " + plusPlus.c.getN());
    System.out.println("n = "  + n);
  }
  public static void main(String[] args) {
    PlusPlus plusPlus = new PlusPlus();
    System.out.println("init");
    System.out.println("c.n = " + plusPlus.c.getN());
    tryPlusPlus(plusPlus);
    tryPlusPlus(plusPlus);
  }
}
