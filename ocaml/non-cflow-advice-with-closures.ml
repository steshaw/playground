(*
 Neel Krishnaswami's "For non-cflow advice..." comment from "Lambda The Ultimate".

 See http://lambda-the-ultimate.org/node/3465#comment-49813
*)

(* An "AOP-style fixed point" -- use backpatching to build a recursive function,
   and then return the ref cell (aka join point) so people can mutate it.
   Peter Landin may have invented this method, btw -- though he was too 
   disciplined to let the ref cell escape!
*)

let aop_fix f =
  let joinpoint = ref (fun _ -> assert false) in
  let () = joinpoint := f (fun z -> !joinpoint z) in
  ((fun z -> !joinpoint z), joinpoint)

(* Here's how you can add before and after advice to a function. By 
   updating the joinpoint/recursive-ref, we can add code to be run on
   recursive calls to a function.
*)

let before_advice advice joinpoint =
  let f = !joinpoint in 
  joinpoint := (fun x -> let () = advice x in f x)

let after_advice advice joinpoint =
  let f = !joinpoint in
  joinpoint := (fun x ->
      let v = f x in
      let () = advice x v in
        v)

(* Of course, every example must be factorial. Notice that we get a 
   function we can call, as well as a join point fjoin. 
*)

let (fact, fjoin) =
  aop_fix (fun fact n -> if n = 0 then 1 else n * fact (n - 1))

(* Add some advice to log what the argument is. *) 

let () =
   before_advice (fun n -> Format.printf "Called with: %d\n" n) fjoin

(* We get the following results *)

(*
# fact 5;;
Called with: 5
Called with: 4
Called with: 3
Called with: 2
Called with: 1
Called with: 0

- : int = 120
*)
