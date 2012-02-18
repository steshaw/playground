(* Datatype's *)

datatype suit = Spades | Hearts | Diamonds | Clubs

fun outranks (Spades, Spades) = false
  | outranks (Spades, _) = true
  | outranks (Hearts, Spades) = false
  | outranks (Hearts, Hearts) = false
  | outranks (Hearts, _) = true
  | outranks (Diamonds, Clubs) = true
  | outranks (Diamonds, _) = false
  | outranks (Clubs, _) = false

datatype 'a option = NONE | SOME of 'a

fun expt (NONE, n) = expt (SOME 2, n)
  | expt (SOME b, 0) = 1
  | expt (SOME b, n) =
    if n mod 2 = 0 then expt (SOME b*b, n div 2) else b * expt (SOME b, n-1)

datatype 'a tree = Empty | Node of 'a tree * 'a * 'a tree

fun height Empty = 0
  | height (Node (lft, _, rht)) = 1 + max (height lft, height rht)

fun size Empty = 0
  | size (Node (lft, _, rht)) = 1 + size lft + size rht

fun size empty = 0
  | size (Node (lft, _, rht)) = 1 + size lft + size rht

datatype 'a tree = Empty | Node of 'a * 'a forest
and 'a forest = Nil | Cons of 'a tree * 'a forest

fun size_tree Empty = 0
  | size_tree (Node (_, f)) = 1 + size_forest f
and size_forest Nil = 0
  | size_forest (Cons (t, f')) = size_tree t + size_forest f'

datatype 'a tree = Empty | Node of 'a branch * 'a branch
and 'a branch = Branch of 'a * 'a tree

fun collect Empty = nil
  | collect (Node (Branch (ld, lt), Branch (rd, rt))) =
    ld :: rd :: (collect lt) @ (collect rt)

datatype int_or_string = Int of int | String of string

datatype expr = Numeral of int | Plus of expr * expr | Times of expr * expr

fun eval (Numeral n) = Numeral n
  | eval (Plus (e1, e2)) =
    let
	val Numeral n1 = eval e1
	val Numeral n2 = eval e2
    in
	Numeral (n1+n2)
    end
  | eval (Times (e1, e2)) =
    let
	val Numeral n1 = eval e1
	val Numeral n2 = eval e2
    in
	Numeral (n1*n2)
    end

datatype expr = 
    Numeral of int | Plus of expr * exp | Times of expr * expr | Recip of expr

fun eval (Numeral n) = Numeral n
  | eval (Plus (e1, e2)) =
    let
	val Numeral n1 = eval e1
	val Numeral n2 = eval e2
    in
	Numeral (n1+n2)
    end
  | eval (Times (e1, e2)) =
    let
	val Numeral n1 = eval e1
	val Numeral n2 = eval e2
    in
	Numeral (n1*n2)
    end
  | eval (Recip e) = 
    let
	val Numeral n = eval e
    in
	Numeral (1 div n)
    end

