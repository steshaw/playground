fun exp 0 = 1
  | exp n = 2 * exp (n-1) ;

fun square (n:int) = n*n
fun double (n:int) = n+n

fun fast_exp 0 = 1
  | fast_exp n =
    if n mod 2 = 0 then
       square (fast_exp (n div 2))
    else
       double (fast_exp (n-1)) ;

fun iterative_fast_exp (0, a) = a
  | iterative_fast_exp (n, a) =
    if n mod 2 = 0 then
       iterative_fast_exp (n div 2, iterative_fast_exp (n div 2, a))
    else
       iterative_fast_exp (n-1, 2*a) ;

fun generalized_iterative_fast_exp (b, 0, a) = a
  | generalized_iterative_fast_exp (b, n, a) =
    if n mod 2 = 0 then
       generalized_iterative_fast_exp (b*b, n div 2, a)
    else
       generalized_iterative_fast_exp (b, n-1, b*a) ;

fun gcd (m:int, 0):int = m
  | gcd (0, n:int):int = n
  | gcd (m:int, n:int):int =
    if m>n then gcd (m mod n, n) else gcd (m, n mod m) ;

fun ggcd (0, n) = (n, 0, 1)
  | ggcd (m, 0) = (m, 1, 0)
  | ggcd (m, n) =
    if m>n then
       let
           val (d, a, b) = ggcd (m mod n, n)
       in
           (d, a, b - a*(m div n))
       end
    else
       let
           val (d, a, b) = ggcd (m, n mod m)
       in
           (d, a - b*(n div m), b)
       end

exception GCD_ERROR

fun checked_gcd (m, n) =
    let
        val (d, a, b) = ggcd (m, n)
    in
        if m mod d = 0 andalso n mod d = 0 andalso d = a*m+b*n then
           d
        else
           raise GCD_ERROR
    end
