
fun last [x] = x
  | last (x::xs) = last xs

local
  fun addlen (n, [])    = n
    | addlen (n, x::xs) = addlen (n+1, xs)
in
  fun length xs = addlen (0, xs)
end;

fun length' xs =
  let fun addlen (n, [])    = n
        | addlen (n, x::xs) = addlen (n+1, xs)
  in addlen (0, xs)
  end;

fun take n []      = []
  | take n (x::xs) = if n > 0 then x :: (take (n-1) xs) else []

fun rtake n xs =
  let 
    fun rtake' n [] acc = acc
      | rtake' n (x::xs) acc =
          if n > 0
          then rtake' (n-1) xs (x::acc)
          else acc
  in
    rtake' n xs []
  end;

fun drop n []      = []
  | drop n (x::xs) = if n > 0 then drop (n-1) xs else x::xs

fun nth n xs = hd (drop n xs)

infixr 5 @@; (* same as built-in @ operator *)
fun ([]      @@ ys) = ys
  | ((x::xs) @@ ys) = x :: (xs @@ ys)

(* grossly inefficient *)
fun nrev [] = []
  | nrev (x::xs) = (nrev xs) @ [x];

fun revAppend [] ys = ys
  | revAppend (x::xs) ys = revAppend xs (x::ys)

(* efficient rev uses revAppend *)
fun rev xs = revAppend xs [];
