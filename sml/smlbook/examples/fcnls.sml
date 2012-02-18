(* Functionals *)

val x = 2            (* x=2 *)
val y = x*x          (* y=4 *)
val x = y*x          (* x=8 *)
val y = x*y          (* y=32 *)

val x = 2
fun f y = x+y
val x = 3
val z = f 4

fun map' (f, nil) = nil
  | map' (f, h::t) = (f h) :: map' (f, t)

val constantly = fn k => (fn a => k)
fun constantly k a = k

fun map f nil = nil
  | map f (h::t) = (f h) :: (map f t)

fun curry f x y = f (x, y)

fun map f l = curry map' f l

fun add_up nil = 0
  | add_up (h::t) = h + add_up t

fun mul_up nil = 1
  | mul_up (h::t) = h * mul_up t

fun reduce (unit, opn, nil) = unit
  | reduce (unit, opn, h::t) = opn (h, reduce (unit, opn, t))

fun add_up l = reduce (0, op +, l)
fun mul_up l = reduce (1, op *, l)

fun mystery l = reduce (nil, op ::, l)

fun better_reduce (unit, opn, l) =
    let
        fun red nil = unit
          | red (h::t) = opn (h, red t)
    in
        red l
    end

fun staged_reduce (unit, opn) =
    let
        fun red nil = unit
          | red (h::t) = opn (h, red t)
    in
        red
    end

fun curried_reduce (unit, opn) nil = unit
  | curried_reduce (unit, opn) (h::t) = opn (h, curried_reduce (unit, opn) t)

fun append (nil, l) = l
  | append (h::t, l) = h :: append(t,l)

fun curried_append nil l = l
  | curried_append (h::t) l = h :: append t l

fun staged_append nil = fn l => l
  | staged_append (h::t) =
    let
        val tail_appender = staged_append t
    in
        fn l => h :: tail_appender l
    end
