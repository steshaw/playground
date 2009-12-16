
// An excercise from Tony Morris.
// See http://blog.tmorris.net/debut-with-a-catamorphism/

trait MyOption[+A] {
  // single abstract method
  def cata[X](some: A => X, none: => X): X

  private def none[A] = new MyOption[A] {
    def cata[X](s: A => X, n: => X) = n
  }

  private def some[A](a: A) = new MyOption[A] {
    def cata[X](s: A => X, n: => X) = s(a)
  }

  private def identity[A](a: A) = a

  def map[B](f: A => B): MyOption[B] = cata(f andThen some, none)

  def flatMap[B](f: A => MyOption[B]): MyOption[B] = cata(f, none)

  def getOrElse[AA >: A](e: => AA): AA = cata(identity[A], e)

  def filter(p: A => Boolean): MyOption[A] = cata(a => if (p(a)) some(a) else none, none)

  def foreach(f: A => Unit): Unit = cata(f, ())

  def isDefined: Boolean = cata(_ => true, false)

  def isEmpty: Boolean = !isDefined

  // WARNING: not defined for None
  def get: A = cata(identity[A], error("None.get"))

  def orElse[AA >: A](o: MyOption[AA]): MyOption[AA] = cata(_ => this, o)

  def toLeft[X](right: => X): Either[A, X] = cata(Left(_), Right(right))

  def toRight[X](left: => X): Either[X, A] = cata(Right(_), Left(left))

  def toList: List[A] = cata(List(_), Nil)

  def iterator: Iterator[A] = cata(Iterator(_), Iterator())

  override def toString: String = cata("Some(" + _ + ")", "None")
}

object MyOption {
  def none[A] = new MyOption[A] {
    def cata[X](s: A => X, n: => X) = n
  }

  def some[A](a: A) = new MyOption[A] {
    def cata[X](s: A => X, n: => X) = s(a)
  }
}
