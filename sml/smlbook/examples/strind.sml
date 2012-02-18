(* Natural numbers in unary *)

datatype nat = Zero | Succ of nat

fun add (m, Zero) = m
  | add (m, Succ n) = Succ (add (m, n))

fun mul (m, Zero) = Zero
  | mul (m, Succ n) = add (mul (m, n), m)

fun double Zero = Zero
  | double (Succ m) = Succ (Succ (double m))

fun exp Zero = Succ Zero
  | exp (Succ m) = double (exp m)


(* Lists *)

(* datatype 'a list = nil | :: of 'a * 'a list *)

fun reverse nil = nil
  | reverse (h::t) = t @ [h]

(* Two-three trees *)

datatype 'a two_three_tree =
    Empty
  | Binary of 'a * 'a two_three_tree * 'a two_three_tree
  | Ternary of 'a * 'a two_three_tree * 'a two_three_tree * 'a two_three_tree

fun size Empty = 0
  | size (Binary (_, t1, t2)) = 1 + size t1 + size t2
  | size (Ternary (_, t1, t2, t3)) = 1 + size t1 + size t2 + size t3

(* Recursion patterns *)

fun nat_recursion base step =
    let
	fun loop Zero = base
	  | loop (Succ m) = step (m, loop m)
    in
	loop
    end

val double = nat_recursion (Zero) (fn (_, result) => Succ (Succ result))
val exp = nat_recursion (Succ Zero) (fn (_, result) => double result)

fun list_recursion base step =
    let
	fun loop nil = base
	  | loop (h::t) = step (h, loop t)
    in
	loop
    end

fun reverse l = list_recursion nil (fn (h, t) => t @ [h]) l

fun two_three_recursion base step2 step3 =
    let
	fun loop Empty = base
	  | loop (Binary (v, t1, t2)) =
	    step2 (v, loop t1, loop t2)
	  | loop (Ternary (v, t1, t2, t3)) =
	    step3 (v, loop t1, loop t2, loop t3)
    in
	loop
    end

fun size t =
    two_three_recursion
    0
    (fn (_, s1, s2) => 1+s1+s2)
    (fn (_, s1, s2, s3) => 1+s1+s2+s3)
    t
