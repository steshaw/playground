(* References *)

val r = ref 0
val s = ref 0
val _ = r := 3
val x = !s + !r
val _ = t := 5
val y = !s + !r
val z = !t + !r

fun rot3 (a, b, c) =
    let
        val t = !a
    in
        a := !b; b := !c; c := t
    end

fun rot3 (a, b, c) =
    let
        val (x, y, z) = (!a, !b, !c)
    in
        a := y; b := z; c := x
    end

fun rot3 (a, b, c) =
    let
        val (ref x, ref y, ref z) = (a, b, c)
    in
        a := y; b := z; c := x
    end

fun imperative_fact (n:int) =
    let
        val result = ref 1
        val i = ref 0
        fun loop () =
            if !i = n then
               ()
            else
               (i := !i + 1; result := !result * !i; loop ())
    in
        loop (); !result
    end

local
      val counter = ref 0
in
      fun tick () = (counter := !counter + 1; !counter)
      fun reset () = (counter := 0)
end

fun new_counter () =
    let
        val counter = ref 0
        fun tick () = (counter := !counter + 1; !counter)
        fun reset () = (counter := 0)
    in
        { tick = tick, reset = reset }
    end

val c1 = new_counter ()
val c2 = new_counter ()
#tick c1;                 (* 1 *)
#tick c1;                 (* 2 *)
#tick c2;                 (* 1 *)
#reset c1;
#tick c1;                 (* 1 *)
#tick c2;                 (* 2 *)

(* possibly circular lists *)

datatype 'a pcl = Pcl of 'a pcell ref
and 'a pcell = Nil | Cons of 'a * 'a pcl;

fun cons (h, t) = Pcl (ref (Cons (h, t)));
fun nill () = Pcl (ref Nil);

fun phd (Pcl (ref (Cons (h, _)))) = h;
fun ptl (Pcl (ref (Cons (_, t)))) = t;

fun stl (Pcl (r as ref (Cons (h, t))), u) =
    (r := Cons (h, u));

val finite = cons (4, cons (3, cons (2, cons (1, nill ()))));

val tail = cons (1, nill());
val infinite = cons (4, cons (3, cons (2, tail)));
val _ = stl (tail, infinite)

local
  fun race (Nil, Nil) = 0
    | race (Cons (_, Pcl (ref c)), Nil) =
      1 + race (c, Nil)
    | race (Cons (_, Pcl (ref c)), Cons (_, Pcl (ref Nil))) =
      1 + race (c, Nil)
    | race (Cons (_, l), Cons (_, Pcl (ref (Cons (_, m))))) =
      1 + race' (l, m)
  and race' (Pcl (r as ref c), Pcl (s as ref d)) =
      if r=s then 0 else race (c, d)
in
  fun size (Pcl (ref c)) = race (c, c)
end

size finite;
size infinite;

fun C 1 = 1
  | C n = sum (fn k => (C k) * (C (n-k))) (n-1)

local
       val limit : int = 100
       val memopad : int option array = Array.array (limit, NONE)
in
       fun C' 1 = 1
         | C' n = sum (fn k => (C k) * (C (n-k))) (n-1)
       and C n =
           if n < limit then
              case Array.sub (memopad, n)
                of SOME r => r
                 | NONE =>
                   let
                       val r = C' n
                   in
                       Array.update (memopad, n, SOME r);
                       r
                   end
            else
               C' n
end
