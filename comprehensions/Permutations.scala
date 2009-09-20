
def permutations[A](a : List[A]):List[List[A]] = a match {
  case Nil => List(List())
  case xs => for (x <- xs; ys <- permutations (xs - x)) yield x::ys
}

println(permutations(List(1,2,3)))
