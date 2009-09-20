object Clock {

  def timeIt[T](name: String)(block: => T) {
    val start = System.currentTimeMillis
    try {
      var i = 0
      while (i < 100000) {
        block
        i += 1
      }
    } finally {
      val duration = System.currentTimeMillis - start
      Console.err.println("%s took %sms (%ss)".format(name, duration, duration/1000.0))
    }
  }

  def timeItOnce[T](name: String)(block: => T) {
    val start = System.currentTimeMillis
    try {
      block
    } finally {
      val duration = System.currentTimeMillis - start
      Console.err.println("%s took %sms".format(name, duration))
    }
  }

}
