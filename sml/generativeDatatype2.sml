(* 
 * See http://mlton.org/GenerativeDatatype 
 *
 * Does not compile.
 *)

datatype t = A | B
val a1 = A
datatype t = A | B
val a2 = A
val _ = if true then a1 else a2
