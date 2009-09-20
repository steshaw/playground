//
// From a commentor on Dick's article.
// Quite complicated. Seems like a Haskell solution but reminds me of O'Caml!
//

object VassilDichev extends Application {
  def vassil = {
    val a = (List.make(4, "Happy birthday ")
      zip (List.tabulate(4, {
        case 2 => "dear friend"
        case _ => "to you"}))
      ) map (Function.tupled(_+_)) mkString ("\n")
    println(a)
  }

  def vassilOverheardOnTwitter = {
    val (d,t)=("Dear XXX","To you")
    List(t,t,d,t) map ("Happy Birthday " + _) foreach println
  }

  import Clock.timeIt

  timeIt("vassil1")(vassil)
  timeIt("vassil2")(vassilOverheardOnTwitter)
}
