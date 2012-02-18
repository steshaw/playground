(* CHESS BOARDS *)

signature BOARD = sig
  type board
  val new : int -> board
  val complete : board -> bool
  val place : board * int -> board
  val safe : board * int -> bool
  val size : board -> int
  val positions : board -> (int * int) list
end

structure Board :> BOARD = struct

  (* representation: size, next free column, number placed, queens *)
  (* rep'n invariant: size >=0, 1<=next free<=size, length(queens) = placed *)
  type board = int * int * int * (int * int) list

  fun new n = (n, 1, 0, nil)

  fun size (n, _, _, _) = n
  fun complete (n, _, k, _) = (k=n)
  fun positions (_, _, _, qs) = qs

  fun place ((n, i, k, qs),j) = (n, i+1, k+1, (i,j)::qs)

  fun threatens ((i,j), (i',j')) =
      i=i' orelse j=j' orelse i+j = i'+j' orelse i-j = i'-j'

  fun conflicts (q, nil) = false
    | conflicts (q, q'::qs) = threatens (q, q') orelse conflicts (q, qs)

  fun safe ((_, i, _, qs), j) = not (conflicts ((i,j), qs))

end

(* SOLUTION BASED ON OPTIONS *)

(* addqueen bd evaluates to SOME bd', where bd' is a complete safe placement
   extending bd, if one exists, and yields NONE otherwise *)
fun addqueen bd =
    let
        fun try j =
            if j > Board.size bd then
               NONE
            else if Board.safe (bd, j) then
               case addqueen (Board.place (bd, j))
                 of NONE => try (j+1)
                  | r as (SOME bd') => r
            else
               try (j+1)
    in
        if Board.complete bd then
           SOME bd
        else
           try 1
    end

fun queens n = addqueen (Board.new n)

exception Fail

(* addqueen bd evaluates to bd', where bd' is a complete safe placement
   extending bd, if one exists, and raises Fail otherwise *)
fun addqueen bd =
    let
        fun try j =
            if j > Board.size bd then
               raise Fail
            else if Board.safe (bd, j) then
               addqueen (Board.place (bd, j))
               handle Fail => try (j+1)
            else
               try (j+1)
    in
        if Board.complete bd then
           bd
        else
           try 1
    end

fun queens n = SOME (addqueen (Board.new n)) handle Fail => NONE

(* SOLUTION USING EXCEPTIONS *)

exception Fail

(* addqueen bd evaluates to bd', where bd' is a complete safe placement
   extending bd, if one exists, and raises Fail otherwise *)
fun addqueen bd =
    let
        fun try j =
            if j > Board.size bd then
               raise Fail
            else if Board.safe (bd, j) then
               addqueen (Board.place (bd, j))
               handle Fail => try (j+1)
            else
               try (j+1)
    in
        if Board.complete bd then
           bd
        else
           try 1
    end

fun queens n = SOME (addqueen (Board.new n)) handle Fail => NONE

(* SOLUTION USING CONTINUATIONS *)

(* addqueen bd evaluates to bd', where bd' is a complete safe placement
   extending bd, if one exists, and otherwise yields the value of fc () *)
fun addqueen (bd, fc) =
    let
        fun try j =
            if j > Board.size bd then
               fc ()
            else if Board.safe (bd, j) then
               addqueen (Board.place (bd, j), fn () => try (j+1))
            else
               try (j+1)
    in
        if Board.complete bd then
           SOME bd
        else
           try 1
    end

fun queens n = addqueen (Board.new n, fn () => NONE)
