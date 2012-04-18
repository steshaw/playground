type 'a exp =
  | Var of string
  | App of 'a exp * 'a exp
  | Lam of string * 'a

type expr = E of expr exp
type cexpr = C of int

let rec lambda_lift e env table =
  match e with
  | Var v -> Var v, table
  | App(e1, e2) ->
      let e1', table = lambda_lift e1 env table in
      let e2', table = lambda_lift e2 env table in
      App(e1', e2'), table
  | Lam(x, E ebody) ->
      let ebody', table = lambda_lift ebody (x :: env) table in
      Lam(x, C(List.length table)), (table @ [x :: env, ebody'])

let rec index x = function
  | [] -> raise Not_found
  | y :: ys -> if x = y then 0 else 1 + (index x ys)

let rec natfold n f init = if n = 0 then init else f (natfold (n-1) f init)

(* compile : (string list * cexpr) -> int -> int * (int list -> string list) *)

let rec compile' (env, e) start =
  match e with
  | Var x ->
      let n = index x env in
      (n + 3,
       (fun _ ->
          ["work := ep\n"] @
          (natfold n (fun acc -> "work := [work] + 1\n" :: acc) []) @
          ["sp := sp + 1\n";
           "[sp] := [work]\n"]))
  | Lam(x, C id) ->
      (5,
       fun locs ->
         ["sp := sp + 1\n";
          "[sp] := hp\n";
          "hp := hp + 2\n";
          Printf.sprintf "[sp] := %d\n" (List.nth locs id);
          "[[sp] + 1] := ep\n"])
  | App(e1, e2) ->
      let len1, f1 = compile' (env, e1) start in
      let len2, f2 = compile' (env, e2) (start + len1) in
      (len1 + len2 + 21,
       fun locs ->
         let code1 = f1 locs in
         let code2 = f2 locs in
         (code1 @ code2 @
          ["work := hp\n";
           "hp := hp + 2\n";
           "[work] := [sp]\n";
           "[[work] + 1] := ep\n";
           "sp := sp - 1\n";
           "newenv := [[sp]]\n";
           "calltgt := [[sp] + 1]\n";
           "sp := sp - 1\n";
           "[sp] := ep\n";
           "sp := sp + 1\n";
           "[sp] := ret\n";
           "sp := sp + 1\n";
           "ep := newenv\n";
           Printf.sprintf "ret := %d\n" (start + len1 + len2 + 16);
           "jump calltgt\n";
           "work := [sp]\n";
           "sp := sp - 1\n";
           "ret := [sp]\n";
           "sp := sp - 1\n";
           "ep := [sp]\n";
           "sp := sp - 1\n"]))

let rec compile_closures table start =
  match table with
  | [] -> ([], [])
  | pair :: tail ->
      let (len, code) = compile' pair start in
      let code lst = code lst @ ["jump ret\n"] in
      let len = len + 1 in
      let (offsets, codes) = compile_closures tail (start + len) in
      (start :: offsets, code :: codes)

let compile e env =
  let ce, table = lambda_lift e env [] in
  let (start, codegen) = compile' (env, ce) 0 in
  let start = start + 1 in
  let codegen = (fun offsets -> codegen offsets @ ["halt\n"]) in
  let (offsets, closuregens) = compile_closures table start in
  codegen offsets @ (List.concat (List.map (fun f -> f offsets) closuregens))
