
fun last [x] = x
  | last (x::xs) = last xs;

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
  | take n (x::xs) = if n > 0 then x :: (take (n-1) xs) else [];

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
  | drop n (x::xs) = if n > 0 then drop (n-1) xs else x::xs;

fun nth n xs = hd (drop n xs);

infixr 5 @@; (* same as built-in @ operator *)
fun ([]      @@ ys) = ys
  | ((x::xs) @@ ys) = x :: (xs @@ ys);

(* grossly inefficient *)
fun nrev [] = []
  | nrev (x::xs) = (nrev xs) @ [x];

fun revAppend [] ys = ys
  | revAppend (x::xs) ys = revAppend xs (x::ys);

(* efficient rev uses revAppend *)
fun rev xs = revAppend xs [];

fun zip _       []      = []
  | zip []       _      = []
  | zip (x::xs) (y::ys) = (x, y) :: (zip xs ys);

fun unzip [] = ([], [])
  | unzip ((x, y) :: ps) = 
  let val (xs, ys) = unzip ps
  in (x::xs, y::ys)
  end;

fun runzip [] xs ys = (xs, ys)
  | runzip ((x,y) :: ps) xs ys = runzip ps (x::xs) (y::ys);

fun powset ([], base)    = [base]
  | powset (x::xs, base) = powset(xs, base) @ powset(xs, x::base);

fun cartprod([], ys) = []
  | cartprod(x::xs, ys) =
      let val xsprod = cartprod(xs, ys)
          fun pairx []        = xsprod
            | pairx (y::ytail) = (x, y) :: (pairx ytail)
      in pairx ys end;
