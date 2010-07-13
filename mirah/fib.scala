def fib(a:Int):Int = {
  if (a < 2) {
    a
  } else {
    fib(a - 1) + fib(a - 2)
  }
}

(1 to 10).foreach {n => println((n,fib(n)))}
