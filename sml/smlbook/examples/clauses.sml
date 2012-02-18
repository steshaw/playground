(* Clausal Function Definitions *)

val 0 = 1-1
val (0,x) = (1-1, 34)
val (0, #"0") = (2-1, #"0")

val recip : int -> int = fn 0 => 0 | n:int => 1 div n

fun recip 0 = 0
  | recip (n:int) = 1 div n
fun not true = false
  | not false = true

fun recip (n:int) = 1 div n
  | recip 0 = 0

fun is_numeric #"0" = true
  | is_numeric #"1" = true
  | is_numeric #"2" = true
  | is_numeric #"3" = true
  | is_numeric #"4" = true
  | is_numeric #"5" = true
  | is_numeric #"6" = true
  | is_numeric #"7" = true
  | is_numeric #"8" = true
  | is_numeric #"9" = true

fun is_numeric #"0" = true
  | is_numeric #"1" = true
  | is_numeric #"2" = true
  | is_numeric #"3" = true
  | is_numeric #"4" = true
  | is_numeric #"5" = true
  | is_numeric #"6" = true
  | is_numeric #"7" = true
  | is_numeric #"8" = true
  | is_numeric #"9" = true
  | is_numeric _ = false

