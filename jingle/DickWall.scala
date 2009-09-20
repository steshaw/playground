object DickWall extends Application {

  def dick1 =
    (1 to 4).map { i =>
      "Happy Birthday %s".format(if (i == 3) "Dear XXX" else "To You")
    }.foreach { println(_) }

  def dick2 =
    (1 to 4).foreach {i =>
      println ("Happy Birthday " + (if (i == 3) "Dear XXX" else "To You"))
    }

  def dick3 =
    for (i <- 1 to 4) println ("Happy Birthday " + (if (i == 3) "Dear XXX" else "To You"))

  import Clock.timeIt

  timeIt("Dick Java") { DickWallJava.dickJava }
  timeIt("dick1") { dick1 }
  timeIt("dick2") { dick2 }
  timeIt("dick3") { dick3 }
}
