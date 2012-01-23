(* 
 * See http://mlton.org/GenerativeDatatype
 *
 * Does not compile.
 *)

functor F () =
   struct
      datatype t = T
   end

structure S1 = F ()
structure S2 = F ()

val _: S1.t -> S2.t = fn x => x
