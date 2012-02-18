Compiler.Control.Lazy.enabled := true;
open Lazy;

datatype lazy 'a stream = Cons of 'a * 'a stream;

val rec lazy ones = Cons (1, ones);

fun shd (Cons (x, _)) = x;
fun stl (Cons (_, s)) = s;
fun lstl (Cons (_, s)) = s;

val rec lazy s = (print "."; Cons (1, s));
val s' = stl s;                              (* prints "." *)
val Cons _ = s';                             (* silent *)

val rec lazy s = (print "."; Cons (1, s));
val s'' = lstl s;                            (* silent *)
val Cons _ = s'';                            (* prints "." *)

fun take 0 s = nil
  | take n (Cons (x, s)) = x :: take (n-1) s;

fun smap f =
    let
	fun lazy loop (Cons (x, s)) = Cons (f x, loop s)
    in
	loop
    end;

fun succ n = n+1;
val one_plus = smap succ;
val rec lazy nats = Cons (0, one_plus nats);

fun sfilter pred =
    let
	fun lazy loop (Cons (x, s)) =
	    if pred x then
	       Cons (x, loop s)
	    else
	       loop s
    in
	loop
    end;

fun m mod n = m - n * (m div n);
fun divides m n = n mod m = 0;

fun lazy sieve (Cons (m, s)) = Cons (m, sieve (sfilter (not o (divides m)) s));
val nats2 = stl (stl nats);
val primes = sieve nats2;

val rec lazy s = Cons ((print "."; 1), s);
val Cons (h, _) = s;                      (* prints ".", binds h to 1 *)
val Cons (h, _) = s;                      (* silent, binds h to 1 *)
