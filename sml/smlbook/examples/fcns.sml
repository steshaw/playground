(* Functions *)

fn x : real => sqrt (sqrt x)

(fn x : real => sqrt (sqrt x)) (16.0)

val fourthroot : real -> real =
    (fn x : real => sqrt (sqrt x))

fun fourthroot (x:real):real = sqrt (sqrt x)

fun pal (s:string):string = s ^ (rev s)
fun double (n:int):int = n + n
fun square (n:int):int = n * n
fun halve (n:int):int = n div 2
fun is_even (n:int):bool = (n mod 2 = 0)

fun f(x:real):real = x+x
fun g(y:real):real = y+y

val x:real = 2.0
fun h(y:real):real = x+y

fun h(x:real):real =
    let val x:real = 2.0 in x+x end * x

