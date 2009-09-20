object OldSchool extends Application {
  def bday = {
    var i = 0
    while (i < 4) {
      println("Happy Birthday " + (if (i==2) "Dear XXX" else "To You"))
      i+=1
    }
  }

  import Clock.timeIt
  timeIt("OldSchool")(bday)
}
