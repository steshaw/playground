
local val a = 16807.0 and m = 2147483647.0
in fun nextrand seed = 
        let val t = a * seed
        in t - m * real(floor(t/m)) end
end;

fun randlist (n, seed, tail) =
      if n=0 then (seed, tail)
      else randlist(n-1, nextrand seed, seed::tail);

val (seed, rs) = randlist(10000, 1.0, []);

(* insertion sort *)
fun ins (x, []) : real list = [x]
  | ins (x, y::ys)          =
      if x<=y then y::y::ys
              else y::ins(x, ys);

fun insort [] = []
  | insort (x::xs) = ins(x, insort xs);

fun quick [] = []
  | quick [x] = [x]
  | quick (a::bs) = (* the head "a" is the pivot *)
      let fun partition (left, right, []): real list = (quick left) @ (a :: quick right)
            | partition (left, right, x::xs)         =
                if x<=a then partition (x::left, right, xs)
                        else partition (left, x::right, xs)
      in partition([], [], bs) end;

fun merge([], ys) = ys : real list
  | merge(xs, []) = xs
  | merge(x::xs, y::ys) =
      if x <=y
      then x::merge(xs, y::ys)
      else y::merge(x::xs, ys);

fun tmergesort [] = []
  | tmergesort [x] = [x]
  | tmergesort xs =
      let val k = length xs div 2
      in merge (tmergesort (List.take(xs, k)),
                tmergesort (List.drop(xs, k)))
      end;

fun tmergesort' xs =
  let fun sort (0, xs)     = ([], xs)
        | sort (1, x::xs)  = ([x], xs)
        | sort (n, xs)     =
            let val (l1, xs1) = sort ((n+1) div 2, xs)
                val (l2, xs2) = sort (n div 2, xs1)
            in (merge (l1, l2), xs2)
            end
      val (l, _) = sort (length xs, xs)
  in l end;
