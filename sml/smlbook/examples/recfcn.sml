(* Recursive Functions *)

val rec factorial : int->int = fn 0 => 1 | n:int => n * factorial (n-1)

fun factorial 0 = 1
  | factorial (n:int) = n * factorial (n-1)

fun fact_helper (0,r:int) = r
  | fact_helper (n:int,r:int) = fact_helper (n-1,n*r)

fun factorial n:int = fact_helper (n, 1)

local
    fun fact_helper (0,r:int) = r
      | fact_helper (n:int,r:int) = fact_helper (n-1,n*r)
in
    fun factorial (n:int) = fact_helper (n,1)
end

(* for n>=0, fib n evaluates to the nth Fibonacci number *)
fun fib 0 = 1
  | fib 1 = 1
  | fib (n:int) = fib (n-1) + fib (n-2)

(* for n>=0, fib' n evaluates to (a, b), where a is the nth
   Fibonacci number and b is the (n-1)st *)
fun fib' 0 = (1, 0)
  | fib' 1 = (1, 1)
  | fib' (n:int) =
    let
	val (a:int, b:int) = fib' (n-1)
    in
	(a+b, a)
    end

fun even 0 = true
  | even n = odd (n-1)
and odd 0 = false
  | odd n = even (n-1)
