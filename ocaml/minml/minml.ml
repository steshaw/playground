type expr =
  | Int of int
  | Var of string
  | BinOp of [ `Add | `Sub | `Leq ] * expr * expr
  | If of expr * expr * expr
  | Apply of expr * expr

type defn =
  | LetRec of string * string * expr

open Camlp4.PreCast;;

let expr = Gram.Entry.mk "expr"
let defn = Gram.Entry.mk "defn"
let prog = Gram.Entry.mk "defn"

EXTEND Gram
  expr:
  [ [ "if"; p = expr; "then"; t = expr; "else"; f = expr ->
	If(p, t, f) ]
  | [ e1 = expr; "<="; e2 = expr -> BinOp(`Leq, e1, e2) ]
  | [ e1 = expr; "+"; e2 = expr -> BinOp(`Add, e1, e2)
    | e1 = expr; "-"; e2 = expr -> BinOp(`Sub, e1, e2) ]
  | [ f = expr; x = expr -> Apply(f, x) ]
  | [ v = LIDENT -> Var v
    | n = INT -> Int(int_of_string n)
    | "("; e = expr; ")" -> e ] ];
  defn:
  [ [ "let"; "rec"; f = LIDENT; x = LIDENT; "="; body = expr ->
	LetRec(f, x, body) ] ];
  prog:
  [ [ defns = LIST0 defn; "do"; run = expr -> defns, run ] ];
END

open Printf

let program, run =
  try Gram.parse prog Loc.ghost (Stream.of_channel stdin) with
  | Loc.Exc_located(loc, e) ->
      printf "%s at line %d\n" (Printexc.to_string e) (Loc.start_line loc);
      exit 1

open Llvm

let ( |> ) x f = f x

type state =
    { fn: llvalue;
      blk: llbasicblock;
      vars: (string * llvalue) list }

let context = global_context ()
let i32_type = i32_type context
let i8_type = i8_type context
let bb state = builder_at_end context state.blk
let new_block state name = append_block context name state.fn
let find state v =
  try List.assoc v state.vars with Not_found ->
    eprintf "Unknown variable %s\n" v;
    raise Not_found
let cont (v, state) dest_blk =
  build_br dest_blk (bb state) |> ignore;
  v, state

let rec expr state = function
  | Int n -> const_int i32_type n, state
  | Var x -> find state x, state
  | BinOp(op, f, g) ->
      let f, state = expr state f in
      let g, state = expr state g in
      let build, name = match op with
	| `Add -> build_add, "add"
	| `Sub -> build_sub, "sub"
	| `Leq -> build_icmp Icmp.Sle, "leq" in
      build f g name (bb state), state
  | If(p, t, f) ->
      let t_blk = new_block state "pass" in
      let f_blk = new_block state "fail" in
      let k_blk = new_block state "cont" in
      let cond, state = expr state p in
      build_cond_br cond t_blk f_blk (bb state) |> ignore;
      let t, state = cont (expr { state with blk = t_blk } t) k_blk in
      let f, state = cont (expr { state with blk = f_blk } f) k_blk in
      let phi = build_phi [t, t_blk; f, f_blk] "join" (bb state) in
      phi, state
  | Apply(f, arg) ->
      let f, state = expr state f in
      let arg, state = expr state arg in
      build_call f [|arg|] "apply" (bb state), state

let defn m vars = function
  | LetRec(f, arg, body) ->
      let ty = function_type i32_type [| i32_type |] in
      let fn = define_function f ty m in
      let vars' = (arg, param fn 0) :: (f, fn) :: vars in
      let body, state =
	expr { fn = fn; blk = entry_block fn; vars = vars' } body in
      build_ret body (bb state) |> ignore;
      (f, fn) :: vars

let int n = const_int i32_type n

let main filename =
  let m = create_module context filename in

  let string = pointer_type i8_type in

  let print =
    declare_function "printf" (var_arg_function_type i32_type [|string|]) m in

  let main = define_function "main" (function_type i32_type [| |]) m in
  let blk = entry_block main in
  let bb = builder_at_end context blk in

  let str s = define_global "buf" (const_stringz context s) m in
  let int_spec = build_gep (str "%d\n") [| int 0; int 0 |] "int_spec" bb in

  let vars = List.fold_left (defn m) [] program in
  let n, _ = expr { fn = main; blk = blk; vars = vars } run in

  build_call print [| int_spec; n |] "" bb |> ignore;

  build_ret (int 0) bb |> ignore;

  if not (Llvm_bitwriter.write_bitcode_file m filename) then exit 1;
  dispose_module m

let () = match Sys.argv with
  | [|_; filename|] -> main filename
  | _ as a -> Printf.eprintf "Usage: %s <file>\n" a.(0)
