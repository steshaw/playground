(* Lists with mutable tails. *)

datatype 'a mutable_list = Nil | Cons of 'a * 'a mutable_list ref

local
   fun ipr (Nil, a) = a
     | ipr (this as (Cons (_, r as ref next)), a) =
       ipr (next, (r := a; this))
in
   (* destroys argument, yields its reversal *)
   fun inplace_reverse l = ipr (l, Nil)
end

(* Queues *)

(* Signature of queues as an abstract type. *)
signature QUEUE = sig

  type 'a queue

  exception Empty

  val new : unit -> 'a queue

  val insert : 'a * 'a queue -> 'a queue

  val remove : 'a queue -> 'a * 'a queue

end

(* Inefficient implementation of a persistent queue as a list.  A sequence
   of n operations takes O(n^2) time in the worst case. *)
structure NaiveQueue :> QUEUE = struct

    type 'a queue = 'a list

    fun new () = nil

    fun insert (x, q) = x::q

    exception Empty

    fun remove [x] = (x, nil)
      | remove (x::xs) =
	let
	    val (y, q) = remove xs
	in
	    (y, x::q)
	end

end

(* Persistent queues with amortized constant-time behavior for
   single-threaded executions of queue operations.  Rep invariant:
   1. front is empty only if the back is empty
   2. list of elements (in order of departure) of the queue (bs, fs)
      is fs @ rev bs *)
structure AmortizedSingleThreadedQueue :> QUEUE = struct

    type 'a queue = 'a list * 'a list

    (* smart constructor to enforce rep inv *)
    fun make_queue (q as (nil, nil)) = q
      | make_queue (q as (bs, nil)) = (nil, rev bs)
      | make_queue q = q

    (* queue operations *)
    fun new () = make_queue (nil, nil)

    fun insert (b, (bs, fs)) = make_queue (b::bs, fs)

    exception Empty

    fun remove (_, nil) = raise Empty
      | remove (bs, f::fs) = (f, make_queue (bs, fs))

end;

(* Amortized constant-time single-threaded queues, variant representation
   in which a queue has the form (bs, sb, fs, sf) satisfying the rep inv:
   1. sb = length bs, sf = length fs
   2. sf >= sb
*)
structure AmortizedSingleThreadedQueue2 :> QUEUE = struct

    type 'a queue = 'a list * int * 'a list * int

    fun make_queue (q as (bs, sb, fs, sf)) =
	if sf >= sb then
	    q
	else
	    (nil, 0, fs @ rev bs, sf+sb)

    fun new () = make_queue (nil, 0, nil, 0)

    fun insert (b, (bs, sb, fs, sf)) = make_queue (b::bs, sb+1, fs, sf)

    exception Empty

    fun remove (_, _, _, 0) = raise Empty
      | remove (bs, sb, f::fs, sf) = (f, make_queue (bs, sb, fs, sf-1))

end

(* Naive attempt to handle the multi-threaded case by memoization.  Fails
   to achieve an amortized constant-time bound in general. (Consider a
   sequence of n inserts, followed by an n-way split consisting of one more
   insert and one remove.  Each remove takes O(n) time, for a total time of
   O(n^2) for O(n) operations.) *)
structure NaiveMemoizedQueue :> QUEUE = struct

    type 'a queue = ('a list * 'a list) ref

    fun make_queue (qv as (nil, nil)) = ref qv
      | make_queue (qv as (bs, nil)) = ref (nil, rev bs)
      | make_queue qv = ref qv

    fun new () = make_queue (nil, nil)

    fun insert (b, ref (bs, fs)) = make_queue (b::bs, fs)

    exception Empty

    fun remove (ref (_, nil)) = raise Empty
      | remove (ref (bs, f::fs)) = (f, make_queue (bs, fs))

end ;

(* Amortized constant-time multi-threaded queues.  Combines specialized
   representation with memoization to achieve amortized constant-time
   behavior, even in the multi-threaded case. *)
structure AmortizedMultiThreadedQueue :> QUEUE = struct

   (* Specialized list representations, with memoization. *)
    datatype 'a special_list_value =
	Nil
      | Cons of 'a * 'a special_list
      | Append of 'a special_list * 'a special_list
      | Reverse of 'a list
    withtype 'a special_list = 'a special_list_value ref

    (* Reverse a list, forming a special_list. *)
    fun revltosl ([], s) = s
      | revltosl (x::xs, s) = revltosl (xs, Cons (x, ref s))

    (* Force a special_list r into Nil/Cons form. *)
    fun inspect (r as ref (Append (xs, ys))) =
	(case inspect xs
	   of Nil =>
	       let
		   val s = inspect ys
	       in
		   r := s; s
	       end
	    | Cons (x, xs') =>
	       let
		   val s = Cons (x, ref (Append (xs', ys)))
	       in
		   r := s; s
	       end)
      | inspect (r as ref (Reverse xs)) =
	let
	    val s = revltosl (xs, Nil)
	in
	    r := s; s
	end
      | inspect (r as ref (nil_or_cons)) = nil_or_cons

    type 'a queue = 'a list * int * 'a special_list * int

    fun make_queue (q as (bs, sb, fs, sf)) =
	if sf >= sb then
	    q
	else
	    (nil, 0, ref (Append (fs, ref (Reverse bs))), sf+sb)

    fun new () = make_queue (nil, 0, ref Nil, 0)

    fun insert (b, (bs, sb, fs, sf)) =
	make_queue (b::bs, sb+1, fs, sf)

    exception Empty

    fun remove (bs, sb, fs, sf) =
	case inspect fs
	  of Nil => raise Empty
	   | Cons (f, fs') =>
	     (f, make_queue (bs, sb, fs', sf-1))

end;
