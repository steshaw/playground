(* 
 * Neel Krishnaswami explains how to conjure a void type in SML
 *
 * Void is false in the C-H correspondence. Also "bottom"
 *
 * See http://lambda-the-ultimate.org/node/1129#comment-12346
 *)

datatype void = Void of void

(* Here, there's no way to actually construct a value of type void. However, we can write a function with a return type of void: *)

fun makev () = Void(makev())

(* val makev : unit -> void *)

(* If you try to call makev, you get an infinite loop, so you can never actually get ahold of a value of type void. *)
