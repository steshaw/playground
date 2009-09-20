object DickWall extends Application {

  def dick1 =
    (1 to 4).map { i =>
      "Happy birthday %s".format(if (i == 3) "dear friend" else "to you")
    }.foreach { println(_) }

  def dick2 =
    (1 to 4).foreach {i =>
      println ("Happy birthday " + (if (i == 3) "dear friend" else "to you"))
    }

  def dick3 =
    for (i <- 1 to 4) println ("Happy birthday " + (if (i == 3) "dear friend" else "to you"))

  import Clock.timeIt

  timeIt("Dick Java")(DickWallJava.dickJava)
  timeIt("dick1")(dick1)
  timeIt("dick2")(dick2)
  timeIt("dick3")(dick3)
}
