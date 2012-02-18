(* Substructures and Functors *)

signature DICT = sig
  type key
  val lt : key * key -> bool
  val eq : key * key -> bool
  type 'a dict
  val empty : 'a dict
  val insert : 'a dict * key * 'a -> 'a dict
  val lookup : 'a dict * key -> 'a
end

signature STRING_DICT = DICT where type key=string
signature INT_DICT = DICT where type key=int

signature DICT = sig
  structure Key : ORDERED
  type 'a dict
  val empty : 'a dict
  val insert : 'a dict * Key.t * 'a -> 'a dict
  val lookup : 'a dict * Key.t -> 'a
end

signature STRING_DICT = DICT where type Key.t=string
signature INT_DICT = DICT where type Key.t=int

exception NotImplemented

structure StringDict :> STRING_DICT = struct
  structure Key : ORDERED = StringLT
  type 'a dict = Key.t BinTree.tree
  val empty = BinTree.empty
  (* ...insert into a BST using Key.lt and Key.eq... *)
  val insert = raise NotImplemented
  (* ...lookup in a BST using Key.lt and Key.eq... *)
  val lookup = raise NotImplemented
end

structure IntDict :> INT_DICT = struct
  structure Key : ORDERED = IntLT
  type 'a dict = Key.t BinTree.tree
  val empty = BinTree.empty
  val insert = raise NotImplemented
  val lookup = raise NotImplemented
end

functor Dict (structure K : ORDERED) :> DICT where type Key.t=K.t =
struct
    structure Key : ORDERED = K
    type 'a dict = Key.t BinTree.tree
    val empty = BinTree.empty
    val insert = raise NotImplemented
    val lookup = raise NotImplemented
end

structure IntDict = Dict (structure K = IntLT)
structure StringDict = Dict (structure K = StringLT)

signature PRIO_QUEUE = sig
    structure Elt : ORDERED
    type prio_queue
    exception Empty
    val empty : prio_queue
    val insert : Elt.t * prio_queue -> prio_queue
    val remove : prio_queue -> Elt.t * prio_queue
end

