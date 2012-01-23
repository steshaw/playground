(*
 * See http://www.cis.uni-muenchen.de/~leiss/polyrec/polyrec.examples.html
 *)

datatype key = 
  Atom of int | Pair of key * key

datatype 'a trie =
  Empty | Branch of ((int * 'a) list) * (('a trie) trie)

exception NoEntry

(* Untypable in SML *)
fun find (Branch((c,a)::l,_), Atom(d)) = 
         if d=c then a else find (Branch(l, Empty), Atom(d))
  | find (Branch(_,t), Pair(p,q)) = find (find (t,p), q)
  | find (_, _) = raise NoEntry
