(*
 * Inspired by discussion at https://groups.google.com/d/msg/pilud/auXjzeJN-vw/m-h1Hqz-H7gJ
 *
 * Mike Austin's code example looks like:
 *
 *  [1..10] map: |n| if n even then n
 *
 *)

module mapOption

let x = [ for x in 1..10 do if x % 2 = 0 then yield x ]

let xs = [1..10]

let even n = n % 2 = 0

let a = xs |> List.filter even

let easyA = [for x in xs do if even x then yield x ]

(*
 *
 * but's let's say we do more then "return" n:
 *
 *   [1..10] map: |n| if n even then n*2
 *
 * From the F# standard library:
 * 
 *   List.choose : ('T -> 'U option) -> 'T list -> 'U list
 *)

let easyB = [for x in xs do if even x then yield x * 2 ]

let b = xs |> List.choose (fun n -> if even n then Some (n * 2) else None)

let ifO p n = if p n then Some n else None

let a' = xs |> List.choose (fun n -> ifO even n)

let b' = xs |> List.choose (fun n -> ifO even n |> Option.map (fun n -> n * 2))

let ifOm p n f = if p n then Some (f n) else None

let b'' = xs |> List.choose (fun n -> ifOm even n (fun n -> n * 2))
