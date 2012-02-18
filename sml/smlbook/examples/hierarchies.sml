signature MY_STRING_DICT =
  sig
    type 'a dict
    val empty : 'a dict
    val insert : 'a dict * string * 'a -> 'a dict
    val lookup : 'a dict * string -> 'a option
  end

structure MyStringDict :> MY_STRING_DICT =
  sig
    datatype 'a dict =
      Empty |
      Node of 'a dict * string * 'a * 'a dict
    val empty = Empty
    fun insert (None, k, v) = Node (Empty, k, v, Empty)
    fun lookup (Empty, _) = NONE
      | lookup (Node (dl, l, v, dr), k) =
        if k < l then		(* string comparison *)
           lookup (dl, k)
        else if k > l then      (* string comparison *)
           lookup (dr, k)
        else
           v
  end

signature MY_INT_DICT =
  sig
    type 'a dict
    val empty : 'a dict
    val insert : 'a dict * int * 'a -> 'a dict
    val lookup : 'a dict * int -> 'a option
  end

structure MyIntDict :> MY_INT_DICT =
  sig
    datatype 'a dict =
      Empty |
      Node of 'a dict * int * 'a * 'a dict
    val empty = Empty
    fun insert (None, k, v) = Node (Empty, k, v, Empty)
    fun lookup (Empty, _) = NONE
      | lookup (Node (dl, l, v, dr), k) =
        if k < l then		(* int comparison *)
           lookup (dl, k)
        else if k > l then      (* int comparison *)
           lookup (dr, k)
        else
           v
  end

signature MY_GEN_DICT =
  sig
    type key
    type 'a dict
    val empty : 'a dict
    val insert : 'a dict * key * 'a -> 'a dict
    val remove : 'a dict * key -> 'a option
  end

signature MY_STRING_DICT =
  MY_GEN_DICT where type key = string

signature MY_INT_DICT =
  MY_GEN_DICT where type key = int

structure MyStringDict :> MY_STRING_DICT =
  struct
    type key = string
    datatype 'a dict =
      Empty |
      Node of 'a dict * key * 'a * 'a dict
    val empty = Empty
    fun insert (None, k, v) = Node (Empty, k, v, Empty)
    fun lookup (Empty, _) = NONE
      | lookup (Node (dl, l, v, dr), k) =
        if k < l then		(* string comparison *)
           lookup (dl, k)
        else if k > l then      (* string comparison *)
           lookup (dr, k)
        else
           v
  end

structure MyIntDivDict :> MY_INT_DICT =
  struct
    type key = int
    datatype 'a dict =
      Empty |
      Node of 'a dict * key * 'a * 'a dict
    fun divides (k, l) = (l mod k = 0)
    val empty = Empty
    fun insert (None, k, v) = Node (Empty, k, v, Empty)
    fun lookup (Empty, _) = NONE
      | lookup (Node (dl, l, v, dr), k) =
        if divides (k, l) then	    (* divisibility test *)
           lookup (dl, k)
        else if divides (l, k) then (* divisibility test *)
           lookup (dr, k)
        else
           v
  end

signature ORDERED =
  sig
    type t
    val lt : t * t -> bool
    val eq : t * t -> bool
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

signature DICT =
  sig
    structure Key : ORDERED
    type 'a dict
    val empty : 'a dict
    val insert : 'a dict * Key.t * 'a -> 'a dict
    val lookup : 'a dict * Key.t -> 'a option
  end

signature STRING_DICT =
  DICT where type Key.t=string

signature INT_DICT =
  DICT where type Key.t=int

structure StringDict :> STRING_DICT =
  struct
    structure Key : ORDERED = LexString
    datatype 'a dict =
      Empty |
      Node of 'a dict * Key.t * 'a dict
    val empty = Empty
    fun insert (None, k, v) = Node (Empty, k, v, Empty)
    fun lookup (Empty, _) = NONE
      | lookup (Node (dl, l, v, dr), k) =
        if Key.lt(k, l) then
           lookup (dl, k)
        else if Key.lt (l, k) then 
           lookup (dr, k)
        else
           v
  end

structure LessIntDict :> INT_DICT =
  struct
    structure Key : ORDERED = LessInt
    datatype 'a dict =
      Empty |
      Node of 'a dict * Key.t * 'a dict
    val empty = Empty
    fun insert (None, k, v) = Node (Empty, k, v, Empty)
    fun lookup (Empty, _) = NONE
      | lookup (Node (dl, l, v, dr), k) =
        if Key.lt(k, l) then
           lookup (dl, k)
        else if Key.lt (l, k) then 
           lookup (dr, k)
        else
           v
  end

structure IntDivDict :> INT_DICT =
  struct
    structure Key : ORDERED = IntDiv
    datatype 'a dict =
      Empty |
      Node of 'a dict * Key.t * 'a dict
    val empty = Empty
    fun insert (None, k, v) = Node (Empty, k, v, Empty)
    fun lookup (Empty, _) = NONE
      | lookup (Node (dl, l, v, dr), k) =
        if Key.lt(k, l) then
           lookup (dl, k)
        else if Key.lt (l, k) then 
           lookup (dr, k)
        else
           v
  end
