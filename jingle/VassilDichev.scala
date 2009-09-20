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

  import Clock.timeIt

  timeIt("Vassil Dichev")(vassil)
}
