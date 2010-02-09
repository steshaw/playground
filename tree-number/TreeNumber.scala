package steshaw

object TreeNumber {

  sealed abstract class Tree[+A] {
    def number(seed: Int): (Tree[(A, Int)], Int) = this match {
      case Leaf(n) => (Leaf((n, seed)), seed+1)
      case Branch(l, r) => {
        val (lt, seed1) = l.number(seed)
        val (rt, seed2) = r.number(seed1)
        (Branch(lt, rt), seed2)
      }
    }
    //def number2(seed:Int) = number(seed)
    val number2 = number _
  }
  final case class Leaf[A](a: A) extends Tree[A]
  final case class Branch[A](left: Tree[A], right: Tree[A]) extends Tree[A]

  def main(args: Array[String]) = {
    def go(tree: Tree[Int]) {
      println(tree)
      println(tree.number(10)._1)
    }
    def go2(tree: Tree[Int]) {
      println(tree)
      println(tree.number2(10)._1)
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
