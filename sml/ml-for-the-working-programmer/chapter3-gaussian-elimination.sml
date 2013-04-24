
fun dotprod([], [])    = 0.0
  | dotprod(x::xs, y::ys) = x * y + dotprod(xs, ys)

fun pivotrow [row] = row : real list
  | pivotrow (row1::row2::rows) =
      if abs(hd row1) >= abs(hd row2)
      then pivotrow (row1::rows)
      else pivotrow (row2::rows);

fun delrow (p, []) = []
  | delrow (p, row::rows) = if Real.==(p, hd row) then rows
                            else row :: delrow (p, rows);

fun scalarprod (k, [])    = [] : real list
  | scalarprod (k, x::xs) = k * x :: scalarprod(k, xs);

fun vectorsum ([], []) = [] : real list
  | vectorsum (x::xs, y::ys) = x + y :: vectorsum (xs, ys);

fun gausselim [row] = [row]
  | gausselim rows =
      let val p::prow = pivotrow rows
          fun elimcol []              = []
            | elimcol ((x::xs)::rows) =
                vectorsum (xs, scalarprod (~x/p, prow)) :: elimcol rows
      in (p::prow) :: gausselim (elimcol (delrow (p, rows)))
      end;

fun solutions []              = [~1.0]
  | solutions ((x::xs)::rows) =
      let val solns = solutions rows
      in ~(dotprod(solns, xs)/x) :: solns end;

val equations = 
  [[  0.0,  1.0,  2.0,  7.0,  7.0]
  ,[ ~4.0,  0.0,  3.0, ~5.0, ~2.0]
  ,[  4.0, ~1.0, ~2.0, ~3.0,  9.0]
  ,[ ~2.0,  1.0,  2.0,  8.0,  2.0]
  ];

val result = gausselim equations;

fun init xs = rev (tl (rev xs));

val solutions = init (solutions result);
