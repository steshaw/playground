(* Variables and Declarations *)

type float = real
type count = int and average = real 

type float = real and average = float

val m : int = 3+2 
val pi : real = 3.14 and e : real = 2.17

val x : float = sin pi

val m : int = 3+2 
val n : int = m*m 

val n : real = 2.17

let
    val m:int = 3
    val n:int = m*m
in
    m*n
end 

val m:int = 2
val r:int =
    let
	val m:int=3
	val n:int=m*m
    in
	m*n
    end * m

val m : int = 0 
val x : real = sqrt(2) 
val c : char = #"a"

