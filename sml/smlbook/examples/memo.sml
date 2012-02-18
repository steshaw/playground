fun sum f 0 = 0
  | sum f n = (f n) + sum f (n-1)

fun p 1 = 1
  | p n = sum (fn k => (p k) * (p (n-k))) (n-1)

local

    val limit = 100
    val memopad : int option Array.array =
	Array.array (limit, NONE)

in

    fun p' 1 = 1
      | p' n = sum (fn k => (p k) * p (n-k)) (n-1)

    and p n =
	if n < limit then
	    case Array.sub (memopad, n) of
		 SOME r => r
	       | NONE =>
		 let
		     val r = p' n
		 in
		     Array.update (memopad, n, SOME r);
		     r
		 end
	else
	    p' n

end

signature SUSP = sig
  type 'a susp
  val force : 'a susp -> 'a
  val delay : (unit -> 'a) -> 'a susp
end

structure Susp :> SUSP = struct
  type 'a susp = unit -> 'a
  fun force t = t ()
  fun delay (t : 'a susp) =
      let
          exception Impossible
          val memo : 'a susp ref = ref (fn () => raise Impossible)
          fun t' () =
              let val r = t () in memo := (fn () => r); r end
      in
          memo := t';
          fn () => (!memo)()
      end
end

val t = Susp.delay (fn () => print "hello\n")
val _ = Susp.force t;
val _ = Susp.force t;

signature SUSP = sig
    type 'a susp
    val force : 'a susp -> 'a
    val delay : (unit -> 'a) -> 'a susp
    val loopback : ('a susp -> 'a susp) -> 'a susp
end

structure Susp :> SUSP = struct
  type 'a susp = unit -> 'a
  fun force t = t ()
  fun delay (t : 'a susp) =
      let
          exception Impossible
          val memo : 'a susp ref = ref (fn () => raise Impossible)
          fun t' () =
              let val r = t () in memo := (fn () => r); r end
      in
          memo := t';
          fn () => (!memo)()
      end
  fun loopback f =
      let
	  exception Circular
	  val r = ref (fn () => raise Circular)
	  fun t () = force (!r)
      in
	  r := f t ; t
      end
end

datatype 'a stream_ = Cons_ of 'a * 'a stream
withtype 'a stream = 'a stream_ Susp.susp

fun ones_loop s = Susp.delay (fn () => Cons_ (1, s))
val ones = Susp.loopback ones_loop

fun bad_loop s = let val r = Susp.force s in Susp.delay (fn () => r) end
(* val bad = Susp.loopback bad_loop   (* raises Circular *) *)
