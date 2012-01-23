(* 
 * See http://www.cis.uni-muenchen.de/~leiss/polyrec/polyrec.examples.html
 *)

(* This is untypable:
fun map f [] = [] 
  | map f (x::xs) = (f x) :: (map f xs) 
  and mapTwice l = map (fn n => 2 * n) l 
  and mapNot l = map not l
*)

(* However, things are easily fixed by defining map by itself *)
fun map f [] = [] 
  | map f (x::xs) = (f x) :: (map f xs) 

fun mapTwice l = map (fn n => 2 * n) l 
and mapNot l = map not l
