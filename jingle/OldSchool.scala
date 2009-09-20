object OldSchool extends Application {

  def bday = {
    var i = 0
    while (i < 4) {
      println("Happy birthday " + (if (i==2) "dear friend" else "to you"))
      i+=1
    }
  }

  import Clock.timeIt

  timeIt("OldSchool")(bday)
}
