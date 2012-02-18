signature ORDERED =
  sig
    type t
    val lt : t * t -> bool
    val eq : t * t -> bool
  end

signature DICT =
  sig
    structure Key : ORDERED
    type 'a dict
    val empty : 'a dict
    val insert : 'a dict * Key.t * 'a -> 'a dict
    val lookup : 'a dict * Key.t -> 'a option
  end

functor DictFun (structure K : ORDERED) :> DICT where type Key.t = K.t =
struct
  structure Key : ORDERED = K
  datatype 'a dict =
    Empty |
    Node of 'a dict * Key.t * 'a dict
  val empty = Empty
  fun insert (None, k, v) =
    Node (Empty, k, v, Empty)
  fun lookup (Empty, \_) = NONE
    | lookup (Node (dl, l, v, dr), k) =
      if Key.lt(k, l) then
         lookup (dl, k)
      else if Key.lt (l, k) then 
         lookup (dr, k)
      else
         v
end

(* Lexicographically ordered strings. *)
structure LexString : ORDERED =
  struct
    type t = string
    val eq = (op =)
    val lt = (op <)
  end

(* Integers ordered conventionally. *)
structure LessInt : ORDERED =
  struct
    type t = int
    val eq = (op =)
    val lt = (op <)
  end

(* Integers ordered by divisibility.*)
structure DivInt : ORDERED =
  struct
    type t = int
    fun lt (m, n) = (n mod m = 0)
    fun eq (m, n) = lt (m, n) andalso lt (n, m)
  end

structure LtIntDict = DictFun (structure K = LessInt)

structure LexStringDict = DictFun (structure K = LexString)

structure DivIntDict = DictFun (structure K = DivInt)
