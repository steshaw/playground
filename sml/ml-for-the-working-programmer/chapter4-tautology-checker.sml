(* ------------------------------------------ *)
(* Utilities from mlton.org/InfixingOperators *)
(* ------------------------------------------ *)

infix  3 <\    fun x <\ f = fn y => f (x, y) (* left section *)
infix  3 \>    fun f \> y = f y              (* left application *)
infixr 3 />    fun f /> y = fn x => f (x, y) (* right section *)
infixr 3 </    fun x </ f = f x              (* right application *)

infix 2 o
infix 0 :=

infix  1 >|    val op>| = op</ (* left pipe *)
infixr 1 |<    val op|< = op\> (* right pipe *)

infix  1 |>    val op|> = op>| (* left pipe as in F# *)
infixr 1 $     val op$ = op|<  (* right pipe as in Haskell *)

fun println p = (print p; print "\n")
(* ------------------------------------------ *)

datatype prop = 
    Atom of string
  | Neg  of prop
  | Conj of prop * prop
  | Disj of prop * prop;

fun implies (p, q) = Disj (Neg p, q);

val rich    = Atom "rich"
and landed  = Atom "landed"
and saintly = Atom "saintly";

(* Assumption 1: landed -> rich i.e. the landed are rich. *)
val assumption1 = implies(landed, rich);

(* Assumption 2: !(saintly or rich) i.e. one cannot be both saintly and rich. *)
val assumption2 = Neg (Conj (saintly, rich));

(* A plausible conclusion is: landed -> !saintly i.e. the landed are not saintly. *)
val conclusion = implies (landed, Neg saintly);

(* The following propositional theorem then, is the goal to be proved. *)
val goal = implies (Conj (assumption1, assumption2), conclusion);

fun show (Atom a)      = a
  | show (Neg p)       = "(~" ^ show p ^ ")"
  | show (Conj (p, q)) = "(" ^ show p ^ " & " ^ show q ^ ")"
  | show (Disj (p, q)) = "(" ^ show p ^ " | " ^ show q ^ ")";

(* Like show but taking precedence into account *)
fun showp (k, Atom a) = a
  | showp (k, Neg p) = "~" ^ showp (3, p)
  | showp (k, Conj (p, q)) =
      if k > 2 then "(" ^ showp (k, p) ^ " & " ^ showp (k, q) ^ ")"
      else showp (2, p) ^ " & " ^ showp (2, q)
  | showp (k, Disj (p, q)) = 
      if k > 1 then "(" ^ showp (k, p) ^ " | " ^ showp (k, q) ^ ")"
      else showp (1, p) ^ " | " ^ showp (1, q);

(* refactoring of showp *)
local
  fun showBinOp (operator, a, b) = a ^ " " ^ operator ^ " " ^ b;
  fun bracket s = "(" ^ s ^ ")";
  fun showpp (k, Atom a) = a
    | showpp (k, Neg p) = "~" ^ showpp (3, p)
    | showpp (k, Conj (p, q)) =
        if k > 2 then bracket |< showBinOp ("&", showpp (k, p), showpp (k, q))
        else showBinOp ("&", showpp (2, p), showpp (2, q))
    | showpp (k, Disj (p, q)) = 
        if k > 1 then bracket |< showBinOp ("|", showpp (k, p), showpp (k, q))
        else showBinOp ("|", showpp (1, p), showpp (1, q));
in
  fun showProp prop = showpp (1, prop)
end;

(* Negation Normal Form - NNF *)
fun nnf (Atom a) = Atom a
  | nnf (Neg (Atom a)) = Neg (Atom a)
  | nnf (Neg (Neg p)) = nnf p
  | nnf (Neg (Conj (p, q))) = nnf (Disj (Neg p, Neg q))
  | nnf (Neg (Disj (p, q))) = nnf (Conj (Neg p, Neg q))
  | nnf (Conj (p, q)) = Conj (nnf p, nnf q)
  | nnf (Disj (p, q)) = Disj (nnf p, nnf q)

fun nnfpos (Atom a)  = Atom a
  | nnfpos (Neg p) = nnfneg p
  | nnfpos (Conj (p, q)) = Conj (nnfpos p, nnfpos q)
  | nnfpos (Disj (p, q)) = Disj (nnfpos p, nnfpos q)
and nnfneg (Atom a) = Neg (Atom a)
  | nnfneg (Neg p)  = nnfpos p
  | nnfneg (Conj (p, q)) = Disj (nnfneg p, nnfneg q)
  | nnfneg (Disj (p, q)) = Conj (nnfneg p, nnfneg q)

(* Computes a disjuction in CNF (Conjuctive Normal Form) *)
fun distrib (p, Conj (q, r)) = Conj (distrib (p, q), distrib (p, r))
  | distrib (Conj (q, r), p) = Conj (distrib (q, p), distrib (r, p))
  | distrib (p, q)           = Disj (p, q)

(* Conjuctive Normal Form - CNF *)
fun cnf (Conj (p, q)) = Conj (cnf p, cnf q)
  | cnf (Disj (p, q)) = distrib (cnf p, cnf q)
  | cnf p             = p (* a "literal" i.e. an atom or an atom's negation *)

val cgoal = cnf $ nnf goal;

(*
 * From mathresources.com's Conjuctive Normal Form page:
 * ((P -> Q) & P) -> Q reduces to the cnf (Q v ~P v P) & (Q v ~Q v ~P)
*)
val p = Atom "p"
val q = Atom "q"
val a = implies(Conj (implies (p, q), p), q)

exception NonCNF;

fun positives (Atom a)       = [a]
  | positives (Neg (Atom _)) = []
  | positives (Disj (p, q))  = positives p @ positives q
  | positives _              = raise NonCNF;

fun negatives (Atom _)       = []
  | negatives (Neg (Atom a)) = [a]
  | negatives (Disj (p, q))  = negatives p @ negatives q
  | negatives _              = raise NonCNF;

infix mem
fun (x mem [])      = false
  | (x mem (y::ys)) = (x = y) orelse (x mem ys);

fun inter ([], ys) = []
  | inter (x::xs, ys) = if x mem ys then x::inter (xs, ys)
                                    else    inter (xs, ys);

fun taut (Conj (p, q)) = taut p andalso taut q
  | taut p             = not (null (inter (positives p, negatives p)));

val r1 = taut cgoal;
val r2 = taut $ cnf $ nnf a;
