object MartinOdersky extends Application {

  def martin1 =
    for (s <- List("To You", "To You", "Dear XXX", "To You"))
      println("Happy Birthday "+s)

  def martin2 = {
    val s = List("To You", "To You", "Dear XXX", "To You") map
      ("Happy Birthday "+_) mkString "\n"
    println(s)
  }

  import Clock.timeIt

  timeIt("martin1")(martin1)
  timeIt("martin2")(martin2)
}
