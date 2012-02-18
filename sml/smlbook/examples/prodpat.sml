(* Products and Patterns *)

val pair : int * int = (2, 3)
val triple : int * real * string = (2, 2.0, "2")
val quadruple 
    : int * int * real * real 
    = (2,3,2.0,3.0)
val pair_of_pairs
    : (int * int) * (real * real)
    = ((2,3),(2.0,3.0))

val pair : int * int = (1+1, 5-2)

val (m:int, n:int) = (7+1,4 div 2)
val (m:int, r:real, s:string) = (7, 7.0, "7")
val ((m:int,n:int), (r:real, s:real)) = ((4,5),(3.1,2.7))
val (m:int, n:int, r:real, s:real) = (4,5,3.1,2.7)

val (m:int,n:int,r:real,s:real) = ((4,5),(3.1,2.7))
val (m:int, r:real) = (7+1,4 div 2)
val (m:int, r:real) = (7, 7.0, "7")

val ((m:int,n:int), (r:real, s:real)) = ((2,3),(2.0,3.0))

type hyperlink =
     { protocol : string,
        address : string,
        display : string }

val mailto_rwh : hyperlink =
    { protocol="mailto",
       address="rwh@cs.cmu.edu",
       display="Robert Harper" }

val { protocol=prot, display=disp, address=addr } = mailto_rwh
val { protocol=prot, address=_, display=_ } = mailto_rwh
val { protocol=prot,... } = intro_home
val { protocol, address, display } = mailto_rwh

val dist : real * real -> real = fn (x:real, y:real) => sqrt (x*x + y*y)

fun dist (x:real, y:real):real = sqrt (x*x + y*y)

fun dist' {x=x:real, y=y:real} = sqrt (x*x + y*y)

fun dist2 (x:real, y:real):real*real = (sqrt (x*x+y*y), abs(x-y))

fun dist (p:real*real):real = sqrt((#1 p)*(#1 p)+(#2 p)*(#2 p))

