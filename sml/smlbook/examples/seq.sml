signature SEQUENCE = sig

  type 'a seq = int -> 'a

  val constantly : 'a -> 'a seq               (* constant sequence *)
  val alternately : 'a * 'a -> 'a seq         (* alternating values *)
  val insert : 'a * 'a seq -> 'a seq

  val map : ('a -> 'b) -> 'a seq -> 'b seq
  val filter : ('a -> bool) -> 'a seq -> 'a seq

  val zip : 'a seq * 'b seq -> ('a * 'b) seq
  val unzip : ('a * 'b) seq -> 'a seq * 'b seq
  val merge : 'a seq * 'a seq -> 'a seq

  val stretch : int -> 'a seq -> 'a seq
  val shrink : int -> 'a seq -> 'a seq

  val take : int -> 'a seq -> 'a list
  val drop : int -> 'a seq -> 'a seq
  val shift : 'a seq -> 'a seq

  val loopback : ('a seq -> 'a seq) -> 'a seq

end

structure Sequence :> SEQUENCE = struct

    type 'a seq = int -> 'a

    fun constantly c n = c
    fun alternately (c,d) n = if n mod 2 = 0 then c else d
    fun insert (x, s) 0 = x
      | insert (x, s) n = s (n-1)

    fun map f s = f o s
    fun filter p s n =
	let
	    val x = s n
	in
	    if p x then x else filter p s (n+1)
	end

    fun zip (s1, s2) n = (s1 n, s2 n)
    fun unzip (s : ('a * 'b) seq) = (map #1 s, map #2 s)
    fun merge (s1, s2) n =
	(if n mod 2 = 0 then s1 else s2) (n div 2)

    fun stretch k s n = s (n div k)
    fun shrink k s n = s (n * k)

    fun drop k s n = s (n+k)
    fun shift s = drop 1 s
    fun take 0 _ = nil
      | take n s = s 0 :: take (n-1) (shift s)

    fun loopback loop n = loop (loopback loop) n

end

open Sequence

val evens : int seq = fn n => 2*n
val odds : int seq = fn n => 2*n+1
val nats : int seq = merge (evens, odds)
fun fibs n =
    (insert (1, insert (1, map (op +) (zip (drop 1 fibs, fibs)))))(n)

fun fibs_loop s = insert (1, insert (1, map (op +) (zip (drop 1 s, s))))
val fibs = loopback fibs_loop

fun bad_loop s n = s n + 1
val bad = loopback bad_loop
(* val _ = bad 0 *)

(* wires *)

datatype level = High | Low | Undef
type wire = level seq
type pair = (level * level) seq

val Z : wire = constantly Low
val O : wire = constantly High

(* clock pulse with given duration of each pulse *)
fun clock (freq:int):wire = stretch freq (alternately (Low, High))

(* combinational logic *)

infixr **
fun (f ** g) (x, y) = (f x, g y)

fun logical_and (Low, _) = Low
  | logical_and (_, Low) = Low
  | logical_and (High, High) = High
  | logical_and _ = Undef

fun logical_not Undef = Undef
  | logical_not High = Low
  | logical_not Low = High

fun logical_nop l = l

val logical_nor = logical_and o (logical_not ** logical_not)

type unary_gate = wire -> wire
type binary_gate = pair -> wire

fun gate f w 0 = Undef
  | gate f w i = f (w (i-1))

val delay : unary_gate = gate logical_nop
val inverter : unary_gate = gate logical_not
val nor_gate : binary_gate = gate logical_nor

(* Flip-flops *)

fun RS_ff (S : wire, R : wire) =
    let
	fun X n = nor_gate (zip (S, Y)) n
	and Y n = nor_gate (zip (X, R)) n
    in
	Y
    end

fun pulse b 0 w i = w i
  | pulse b n w 0 = b
  | pulse b n w i = pulse b (n-1) w (i-1)

val S = pulse Low 2 (pulse High 2 Z)
val R = pulse Low 6 (pulse High 2 Z)
val Q = RS_ff (S, R)
val _ = take 20 Q
val X = RS_ff (S, S)			(* unstable! *)
val _ = take 20 X

fun loopback2 (f : wire * wire -> wire * wire) =
    unzip (loopback (zip o f o unzip))

fun RS_ff' (S : wire, R : wire) =
    let
	fun RS_loop (X, Y) =
	    (nor_gate (zip (S, Y)), nor_gate (zip (X, R)))
    in
	loopback2 RS_loop
    end
