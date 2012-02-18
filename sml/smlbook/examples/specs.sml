fun fib 0 = 1
  | fib 1 = 1
  | fib n = fib (n-1) + fib (n-2)

fun fib' 0 = (1, 0)
  | fib' 1 = (1, 1)
  | fib' n =
    let
        val (a, b) = fib' (n-1)
    in
        (a+b, a)
    end

fun fib (n:int):int =
  case n
    of 0 => 1
     | 1 => 1
     | n => fib (n-1) + fib (n-2)

local
  exception PreCond
  fun unchecked_fib 0 = 1
    | unchecked_fib 1 = 1
    | unchecked_fib n =
      unchecked_fib (n-1) + unchecked_fib (n-2)
in
  fun checked_fib n =
    if n < 0 then
       raise PreCond
    else
       unchecked_fib n
end

fun bad_checked_fib n =
  if n < 0 then
     raise PreCond
  else
     case n
       of 0 => 1
        | 1 => 1
        | n => bad_checked_fib (n-1) + bad_checked_fib (n-2)
