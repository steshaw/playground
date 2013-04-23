
(* Like List.foldl *)
fun foldl f initial []      = initial
  | foldl f initial (x::xs) = foldl f (f (x, initial)) xs

fun foldlCurried f initial []      = initial
  | foldlCurried f initial (x::xs) = foldlCurried f (f x initial) xs

(* applying the parameters to f the wrong way around *)
fun foldlWrong f initial []      = initial
  | foldlWrong f initial (x::xs) = foldlWrong f (f initial x) xs

(* Like List.foldr *)
fun foldr f initial []      = initial
  | foldr f initial (x::xs) = f (x, (foldr f initial xs))

fun foldrCurried f initial []      = initial
  | foldrCurried f initial (x::xs) = f x (foldrCurried f initial xs)

fun map f = foldr (fn (x, xs) => f x :: xs) [];
