
trait MyOption[+A] {
  // Single abstract method.
  def cata[X](some: A => X, none: => X): X

  private def none[A] = new MyOption[A] {
    def cata[X](s: A => X, n: => X) = n
  }

  private def some[A](a: A) = new MyOption[A] {
    def cata[X](s: A => X, n: => X) = s(a)
  }

  private def identity[A](a: A) = a

  def map[B](f: A => B): MyOption[B] = cata((a:A) => some(f(a)), none)

  def flatMap[B](f: A => MyOption[B]): MyOption[B] = cata(f, none)

  def getOrElse[AA >: A](e: => AA): AA = cata(identity[A], e)

  def filter(p: A => Boolean): MyOption[A] = cata((a:A) => if (p(a)) some(a) else none, none)

  def foreach(f: A => Unit): Unit = cata(f(_), none)

  def isDefined: Boolean = cata((a: A) => true, false)

  def isEmpty: Boolean = !isDefined

  // WARNING: not defined for None
  def get: A = cata(identity[A], error("undefined"))

  def orElse[AA >: A](o: MyOption[AA]): MyOption[AA] = cata((a: A) => this, o)

  def toLeft[X](right: => X): Either[A, X] = cata(Left(_), Right(right))

  def toRight[X](left: => X): Either[X, A] = cata(Right(_), Left(left))

  def toList: List[A] = cata(List(_), Nil)

  def iterator: Iterator[A] = cata(Iterator(_), Iterator())
}

object MyOption {
  def none[A] = new MyOption[A] {
    def cata[X](s: A => X, n: => X) = n
  }

  def some[A](a: A) = new MyOption[A] {
    def cata[X](s: A => X, n: => X) = s(a)
  }
}
