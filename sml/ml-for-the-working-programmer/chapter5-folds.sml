
(**
 * Like SML's List.foldl.
 * Notice that foldl is curried, whereas f is uncurried.
 *)
fun foldl f initial []      = initial
  | foldl f initial (x::xs) = foldl f (f (x, initial)) xs

(** Like SML's List.foldl except that f is curried. *)
fun foldlCurried f initial []      = initial
  | foldlCurried f initial (x::xs) = foldlCurried f (f x initial) xs

(* applying the parameters to f the wrong way around *)
fun foldlWrong f initial []      = initial
  | foldlWrong f initial (x::xs) = foldlWrong f (f initial x) xs

(* Like SML's List.foldr - f is uncurried *)
fun foldr f initial []      = initial
  | foldr f initial (x::xs) = f (x, (foldr f initial xs))

(* Like SML's List.foldr - f is curried *)
fun foldrCurried f initial []      = initial
  | foldrCurried f initial (x::xs) = f x (foldrCurried f initial xs)

fun map f = foldr (fn (x, xs) => f x :: xs) [];

fun reverse xs = foldl op:: [] xs;

reverse [1,2,3] = 3 :: (2 :: (1 :: []));

(* foldLeft with Haskell-like signature. i.e. f's arguments are flipped from foldr. *)
fun foldLeft f initial []      = initial
  | foldLeft f initial (x::xs) = foldLeft f (f (initial, x)) xs;

val fcons = fn (xs, x) => x :: xs;

fun reverseList xs = foldLeft fcons [] xs;

reverseList [1,2,3];
foldLeft fcons [] [1,2,3];
foldLeft fcons (fcons ([], 1)) [2,3];
foldLeft fcons (fcons ([], 1)) [2,3];
foldLeft fcons (fcons (fcons ([], 1), 2)) [3];
foldLeft fcons (fcons (fcons (fcons ([], 1), 2), 3)) [];
fcons (fcons (fcons ([], 1), 2), 3);

infix fcons;
[] fcons 1 fcons 2 fcons 3;
(([] fcons 1) fcons 2) fcons 3;

(* foldRight is just like foldr above *)
val foldRight = foldr;
fun copy xs = foldr op:: [] xs;

copy [1,2,3];
foldr op:: [] [1,2,3];
op::(1, foldr op:: [] [2,3]);
op::(1, op::(2, foldr op:: [] [3]));
op::(1, op::(2, op::(3, foldr op:: [] [])));
op::(1, op::(2, op::(3, [])));
1 :: 2 :: 3 :: [];
1 :: (2 :: (3 :: []));

val cons = op::;
infixr cons;
1 cons 2 cons 3 cons [];
1 cons (2 cons (3 cons []));

(* filter :: (a -> Bool) -> List a -> List a *)
fun filter p = foldr (fn (x, xs) => if p x then x :: xs else xs) []

(**
 * concat :: List (List a) -> List a
 * Note: SML quibble - cannot define this as "fun concat = ..." as mentions no arguments 
 *)
fun concat xs = foldr (fn (x, xs) => x @ xs) [] xs; (* seems inefficient *)

(**
 * concatMap :: (a -> List b) -> List a -> List b
 *)
fun concatMap f = foldr (fn (x, xs) => f x @ xs) [];

fun repeat 0 a = []
  | repeat n a = a :: repeat (n-1) a;
