package steshaw

// This differs to other versions of the tree numbering as it clobbers the element of the tree and therefore
// also assumes that it is an Int.
object TreeNumberImperativeStyle {

  sealed abstract class Tree[+A]
  final case class Leaf[A](var a: A) extends Tree[A]
  final case class Branch[A](left: Tree[A], right: Tree[A]) extends Tree[A]

  def walk[A](tree: Tree[A], next: () => A):Unit = tree match {
    case leaf@Leaf(n) => leaf.a = next()
    case Branch(l, r) => {
      walk(l, next)
      walk(r, next)
    }
  }

  def number(tree: Tree[Int]) {
    var i = 1
    def next() = {
      var result = i
      i += 1
      result
    }
    walk(tree, next)
  }

  def main(args: Array[String]) = {
    def go(tree: Tree[Int]) {
      println(tree)
      number(tree)
      println(tree)
    }

    go(Branch(Branch(Leaf(2), Leaf(6)), Leaf(9)))
    go(Branch(Branch(Leaf(2), Branch(Leaf(4), Leaf(5))), Leaf(9)))
  }
}
