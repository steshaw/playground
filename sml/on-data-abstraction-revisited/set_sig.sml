signature SET = sig
  type Set
  val empty: Set
  val insert: Set * int -> Set
  val isEmpty: Set -> bool
  val contains: Set * int -> bool
end
