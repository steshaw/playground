(* Exceptions *)

fun hd (h::_) = h

hd nil

exception Factorial

fun checked_factorial n =
    if n < 0 then
	raise Factorial
    else if n=0 then
	1
	 else
	     n * checked_factorial (n-1)

exception Factorial

local
    fun fact 0 = 1
      | fact n = n * fact (n-1)
in
    fun checked_factorial n =
	if n >= 0 then
	    fact n
	else
	    raise Factorial
end 

fun factorial_driver () =
    let
        val input = read_integer ()
        val result = makestring (checked_factorial input)
    in
        print result
    end
    handle Factorial => print "Out of range.\n"


fun factorial_driver () =
    let
        val input = read_integer ()
        val result = makestring (checked_factorial input)
        val _ = print result
    in
        factorial_driver ()
    end
    handle EndOfFile => print "Done.\n"
         | SyntaxError =>
	   let val _ = print "Syntax error.\n" in factorial_driver () end
         | Factorial =>
           let val _ = print "Out of range.\n" in factorial_driver () end

exception Change

fun change _ 0 = nil
  | change nil _ = raise Change
  | change (coin::coins) amt =
    if coin > amt then
	change coins amt
    else
       (coin :: change (coin::coins) (amt-coin))
       handle Change => change coins amt
