object TonyParser {
  val tokens = List(('(', ')'), ('[', ']'))
 
  def parse(s: String) =
    s.foldRight[Option[String]](Some(""))((a, b) => b flatMap
      (ss => {
        val s = ss.toList
        (lookup(tokens map { case (x, y) => (y, x) }, a)
          map (t => (a::s)) orElse
        (lookup(tokens, a) flatMap (v => s match {
          case Nil => None
          case h :: t => if(v == h) Some(t) else None
        }))) map (_.mkString)
      })) exists (_.isEmpty)
 
  def main(args: Array[String]) {
    args foreach (parse _ andThen println)
  }
 
  // The Scala API needs hand-holding
  def lookup[A, B](x: List[(A, B)], a: A) =
    x.find { case (aa, _) => a == aa } map (_._2)
}
