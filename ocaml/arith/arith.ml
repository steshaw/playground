(*
 * Arithmetic expression evaluator example.
 * 
 * See http://ocamlnews.blogspot.com/2010/02/recursive-descent-parsing-with-ocamls.html
 *)

let rec factor = parser
  | [< ''('; e = expr; '')' >] -> e
  | [< 'c >] -> int_of_string (String.make 1 c)

and term = parser
  | [< e1 = factor; e = term_aux e1 >] -> e
and term_aux e1 = parser
  | [< ''*'; e2 = term >] -> e1 * e2
  | [< ''/'; e2 = term >] -> e1 / e2
  | [< >] -> e1

and expr = parser
  | [< e1 = term; e = expr_aux e1 >] -> e
and expr_aux e1 = parser
  | [< ''+'; e2 = expr >] -> e1 + e2
  | [< ''-'; e2 = expr >] -> e1 - e2
  | [< >] -> e1

let rec statement = parser
  | [< e = expr; '';'; ''.'; stream >] ->
      Printf.printf "= %d\n%!" e;
      statement stream

let rec read() = match input_char stdin with
  | ' ' | '\t' | '\n' -> [< read() >]
  | c -> [< 'c; read() >]

let () = statement (read())
