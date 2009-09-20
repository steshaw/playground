val a = List(1,2,3)
val b = List(4,5,6)

val result = for(i <- a; j <- b) yield (i,j)

println(result)
