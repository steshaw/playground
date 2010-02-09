package steshaw

object TreeNumberWithStateMonad {

  sealed abstract class Tree[+A]
  final case class Leaf[A](a: A) extends Tree[A]
  final case class Branch[A](left: Tree[A], right: Tree[A]) extends Tree[A]

  // My implementation of the State monad following the initial template from Tony's post.
  trait State[S, A] {
    val s: Function[S, (S, A)]
    def flatMap[B](f: A => State[S, B]): State[S, B] = new State[S, B] {
      override val s: Function[S, (S, B)] = (x:S) => State.this.s(x) match {
        case (s, a) => f(a).s(s)
      }
    }
    def map[B](f: A => B): State[S, B] = new State[S, B] {
      override val s: Function[S, (S, B)] = (s0:S) => State.this.s(s0) match {
        case (s, a) => (s, f(a))
      }
    }
  }

  def init[S] = new State[S, S] {
    override val s: Function[S, (S, S)] = (init => (init, init))
  }
  def modify[S](f: S => S) = new State[S, Unit] {
    override val s: Function[S, (S, Unit)] = (init => (f(init), ()))
  }

  def number[A](t: Tree[A]): State[Int, Tree[(A, Int)]] = t match {
    case Leaf(x) =>
      for(s <- init[Int]; n <- modify((_:Int) + 1))
        yield Leaf((x, s))
    case Branch(l, r) =>
      for(lt <- number(l); rt <- number(r))
        yield Branch(lt, rt)
  }

  type NumTree[A] = Tree[(A, Int)]

  def number2[A](t: Tree[A]): State[Int, NumTree[A]] = t match {
    case Leaf(x) =>
      init[Int] flatMap ((s:Int) => modify[Int](1+) map ((_:Unit) => Leaf((x, s))))
    case Branch(l, r) =>
      number(l) flatMap((lt:NumTree[A]) => number(r) map ((rt:NumTree[A]) => Branch(lt, rt)))
  }

  def main(args: Array[String]) = {
    def go(tree: Tree[Int]) {
      println(tree)
      println(number(tree).s(10)._2)
    }
    def go2(tree: Tree[Int]) {
      println(tree)
      println(number2(tree).s(10)._2)
    }

    val t1 = Branch(Branch(Leaf(2), Leaf(6)), Leaf(9))
    val t2 = Branch(Branch(Leaf(2), Branch(Leaf(4), Leaf(5))), Leaf(9))

    go(t1)
    go(t2)
    println

    go2(t1)
    go2(t2)
  }

}
