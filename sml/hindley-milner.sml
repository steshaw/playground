(* Hindley-Milner Type Inference. http://ian-grant.net/hm *)

datatype term = Tyvar of string
              | Tyapp of string * (term list)

fun subs [] term = term
  | subs ((t1,v1)::ss) (term as Tyvar name) = 
       if name=v1 then t1 else subs ss term
  | subs _ (term as Tyapp(name,[])) = term
  | subs l (Tyapp(name,args)) = 
       let fun arglist r [] = rev r
             | arglist r (h::t) = 
                   arglist ((subs l h)::r) t
       in
          Tyapp(name, arglist [] args)
       end

fun compose [] s1 = s1
  | compose (s::ss) s1 =
      let fun iter r s [] = rev r  
            | iter r s ((t1,v1)::ss) = 
                 iter (((subs [s] t1),v1)::r) s ss
      in
         compose ss (s::(iter [] s s1))
      end

exception Unify of string

fun unify t1 t2 =
   let fun iter r t1 t2 = 
       let fun occurs v (Tyapp(name,[])) = false
          | occurs v (Tyapp(name,((Tyvar vn)::t))) =  
                        if vn=v then true else occurs v (Tyapp(name,t))
          | occurs v (Tyapp(name,(s::t))) =  
                        occurs v s orelse occurs v (Tyapp(name,t))
          | occurs v (Tyvar vn) = vn=v
       fun unify_args r [] [] = rev r
          | unify_args r [] _ = raise Unify "Arity"
          | unify_args r _ [] = raise Unify "Arity"
          | unify_args r (t1::t1s) (t2::t2s) = 
               unify_args (compose (iter [] (subs r t1) 
                                            (subs r t2)) r) t1s t2s
    in  
       case (t1,t2) of
          (Tyvar v1,Tyvar v2) => if (v1 = v2) then [] else ((t1, v2)::r)
        | (Tyvar v,Tyapp(_,[])) => ((t2, v)::r)
        | (Tyapp(_,[]),Tyvar v) => ((t1, v)::r)
        | (Tyvar v,Tyapp _) => 
             if occurs v t2 then raise Unify "Occurs" else ((t2, v)::r)
        | (Tyapp _,Tyvar v) => 
             if occurs v t1 then raise Unify "Occurs" else ((t1, v)::r)
        | (Tyapp(name1,args1),Tyapp(name2,args2)) => 
                if (name1=name2) 
                   then unify_args r args1 args2 
                   else raise Unify "Const"
    end
in
   iter [] t1 t2
end

datatype typescheme = Forall of string * typescheme
                    | Type of term

fun mem p l =
   let fun iter [] = false
         | iter (x::xs) = (x=p) orelse iter xs
   in iter l end

fun fbtyvars f b (Tyvar v) = if (mem v b) then (f,b) else (v::f,b)
  | fbtyvars f b (Tyapp(name,args)) = 
      let fun iter r [] = r
            | iter r (t::ts) = 
                let val (f,b) = fbtyvars r b t 
                in 
                   iter f ts 
                end
      in
         let val fvs = iter f args in (fvs,b) end
      end

fun fbtsvs f b (Forall(v,s)) = fbtsvs f (v::b) s
  | fbtsvs f b (Type t) = fbtyvars f b t

fun tyvars t = 
   let val (f,b) = fbtyvars [] [] t in
      f@b
   end

fun varno "" = ~1
  | varno v =
    let val vl = explode v
        val letter = (ord (hd vl)) - (ord #"a")
        fun primes r [] = r | primes r (h::t) = 
              if h = #"\039" then primes (r+26) t else ~1
    in 
       if letter >= 0 andalso letter <= 25 
          then primes letter (tl vl) else ~1
    end

fun lastusedtsvar nv sigma =
   let val vars = let val (f,b) = fbtsvs [] [] sigma in f@b end
       fun iter r [] = r
         | iter r (h::t) =
               let val vn = varno h in 
                  if vn > r then iter vn t else iter r t 
               end
   in
      (iter nv vars)
   end

fun lastfreetsvar nv sigma =
   let val (vars,_) = fbtsvs [] [] sigma
       fun iter r [] = r
         | iter r (h::t) =
               let val vn = varno h in 
                  if vn > r then iter vn t else iter r t 
               end
   in
      (iter nv vars)
   end

fun newvar v =
   let val nv = v+1
       fun prime v 0 = v | prime v n = prime (v^"'") (n-1)
       val primes = nv div 26
       val var = str(chr ((ord #"a") + (nv mod 26)))
   in
      (nv,prime var primes)
   end

fun tssubs nv [] sigma = (nv, sigma)
  | tssubs nv ((tvp as (t,v))::tvs) sigma =
     let val (fvs,_) = fbtyvars [] [] t
         fun iter nv rnss (tvp as (t,v)) (ts as (Forall(sv,sts))) = 
           if (sv = v) then (nv, ts) else
              if mem sv fvs then 
                  let val (nv,newv) = newvar nv
                      val (nv,sigma') = 
                        iter nv (compose [(Tyvar newv,sv)] rnss) tvp sts
                  in 
                     (nv, Forall(newv,sigma'))
                  end 
              else let val (nv,sigma') = iter nv rnss tvp sts
                   in
                      (nv,Forall(sv,sigma'))
                   end
           | iter nv rnss tvp (Type term) = 
              (nv,(Type (subs [tvp] (subs rnss term))))
         val (nv, sigma') = iter nv [] tvp sigma
     in
        tssubs nv tvs sigma'
     end

exception Assum of string

fun assq p l =
   let fun iter [] = raise Assum p
         | iter ((k,v)::xs) = if (k=p) then v else iter xs
   in iter l end

fun fassumvars Gamma =
   let fun iter f [] = f
     | iter f ((_,ts)::Gamma') =
        let val (fvs,_) = fbtsvs f [] ts in
           iter (f@fvs) Gamma'
        end
   in
      iter [] Gamma
   end

fun assumvars Gamma =
   let fun iter f [] = f
         | iter f ((_,ts)::Gamma') =
            let val (fvs,bvs) = fbtsvs f [] ts
            in
               iter (f@fvs@bvs) Gamma'
            end
   in
      iter [] Gamma
   end

fun lastfreeassumvar Gamma =
   let fun iter r [] = r
         | iter r ((_,sigma)::Gamma') =
              iter (lastfreetsvar r sigma) Gamma'
   in
      iter ~1 Gamma
   end

fun assumsubs nv S Gamma =
   let fun iter r nv S [] = (nv, rev r)
     | iter r nv S ((v,sigma)::Gamma') = 
         let val (nv, sigma') = tssubs nv S sigma
         in
             iter ((v,sigma')::r) nv S Gamma'
         end
   in
      iter [] nv S Gamma
   end

fun tsclosure Gamma tau =
   let val favs = fassumvars Gamma
       val (ftvs,_) = fbtyvars [] [] tau
       fun iter bvs [] = Type tau
         | iter bvs (v::vs) = 
              if (mem v favs) orelse (mem v bvs) 
                    then iter bvs vs 
                    else Forall(v,iter (v::bvs) vs)
   in
      iter [] ftvs
   end

datatype exp = Var of string
             | Comb of exp * exp
             | Abs of string * exp
             | Let of (string * exp) * exp

infixr -->
fun tau1 --> tau2 = Tyapp("%f",[tau1,tau2])

fun W nv Gamma e =
   case e of 
      (Var v) => 
         let fun tsinst nv (Type tau) = (nv, tau)
               | tsinst nv (Forall(alpha,sigma)) = 
                     let val (nv, beta) = newvar (lastusedtsvar nv sigma)
                         val (nv, sigma') = 
                           (tssubs nv [(Tyvar beta,alpha)] sigma)
                     in
                        tsinst nv sigma'
                     end
             val (nv, tau) = tsinst nv (assq v Gamma)
         in
            (nv, ([], tau))
         end
     | (Comb(e1,e2)) => 
          let val (nv, (S1,tau1)) = W nv Gamma e1
             val (nv, S1Gamma) = assumsubs nv S1 Gamma
             val (nv, (S2,tau2)) = W nv S1Gamma e2
             val S2tau1 = subs S2 tau1
             val (nv,beta) = newvar nv
             val V = unify S2tau1 (tau2 --> Tyvar beta)
             val Vbeta = subs V (Tyvar beta)
             val VS2S1 = compose V (compose S2 S1)
         in 
             (nv, (VS2S1, Vbeta))
         end
    | (Abs(v,e)) =>
         let val (nv,beta) = newvar nv
             val (nv,(S1,tau1)) = W nv ((v,Type (Tyvar beta))::Gamma) e
             val S1beta = subs S1 (Tyvar beta)
         in 
            (nv, (S1,(S1beta --> tau1)))
         end 
    | (Let((v,e1),e2)) =>
         let val (nv, (S1,tau1)) = W nv Gamma e1
             val (nv, S1Gamma) = assumsubs nv S1 Gamma
             val (nv, (S2,tau2)) = 
                   W nv ((v,tsclosure S1Gamma tau1)::S1Gamma) e2
             val S2S1 = compose S2 S1
         in 
            (nv, (S2S1,tau2))
         end

fun principalts Gamma e =
   let val (var, (S, tau)) = W (lastfreeassumvar Gamma) Gamma e 
       val (_,SGamma) = assumsubs var S Gamma
   in
      tsclosure SGamma tau
   end

fun pptsterm tau =
   let fun iter prec (Tyvar name) = ""^name
     | iter prec (Tyapp(name,[])) = name
     | iter prec (Tyapp("%f",[a1,a2])) = 
         let fun maybebracket s = if prec <= 10 then s else "("^s^")"
         in
            maybebracket ((iter 11 a1)^" -> "^(iter 10 a2))
         end
     | iter prec (Tyapp(name,args)) = 
         let fun arglist r [] = r
               | arglist r (h::t) = 
                    arglist (r^(iter 30 h)^(if t=[] then "" else ", ")) t
         in  
            if (length args) > 1 then (arglist "(" args)^") "^name 
                                 else (arglist "" args)^" "^name
         end
   in
       iter 10 tau
   end

fun ppterm (Tyvar name) = name
  | ppterm (Tyapp(name,[])) = name
  | ppterm (Tyapp(name,args)) = 
      let fun arglist r [] = r
            | arglist r (h::t) = 
                 arglist (r^(ppterm h)^(if t=[] then "" else ",")) t
      in  
         name^(arglist "(" args)^")"
      end

fun ppsubs s =
   let fun iter r [] = r^"]"
         | iter r ((term,var)::t) = 
               iter (r^(ppterm term)^"/"^var^(if t=[] then "" else ",")) t
    in iter "[" s end

fun ppexp e =
   let fun ppe r e =
      case e of 
         (Var v) => r^v
       | (Comb(e1,e2)) => r^"("^(ppe "" e1)^" "^(ppe "" e2)^")" 
       | (Abs(v,e)) => r^"(\\"^v^"."^(ppe "" e)^")"
       | (Let((v,e1),e2)) => r^"let "^v^"="^(ppe "" e1)^" in "^(ppe "" e2)
   in
      ppe "" e
   end

fun ppts sigma =
   let fun iter r (Forall(sv,sts)) = iter (r^"!"^sv^".") sts  
         | iter r (Type term) = r^(pptsterm term)
   in
      iter "" sigma
   end

fun ppassums Gamma =
   let fun iter r [] = r
         | iter r ((v,ts)::assums) = 
              iter (r^v^":"^(ppts ts)^(if assums=[] then "" else ",")) assums
   in
      iter "" Gamma
   end

(* Examples *)

(* Unification *)

val x = Tyvar "x"
val y = Tyvar "y"
val z = Tyvar "z"

fun apply s l = Tyapp(s,l)

val a = apply "a" []
fun j(x, y, z) = apply "j" [x, y, z]
fun f(x, y) = apply "f" [x, y]

val t1 = j(x,y,z)
val t2 = j(f(y,y), f(z,z), f(a,a));

ppterm t1;
ppterm t2;

val U = unify t1 t2;
ppsubs U;

print ((ppterm (subs U t1))^"\n");
print ((ppterm (subs U t2))^"\n");

(* Constructors for types *)

fun mk_func name args = Tyapp(name,args)
fun mk_nullary name = mk_func name []
fun mk_unary name arg = mk_func name [arg]
fun mk_binary name arg1 arg2 = mk_func name [arg1, arg2]
fun mk_ternary name arg1 arg2 arg3 = mk_func name [arg1, arg2, arg3]

fun pairt t1 t2 = mk_binary "pair" t1 t2
fun listt t = mk_unary "list" t
val boolt = mk_nullary "bool"

(* Type variables *)

val alpha = Tyvar "a"
val beta = Tyvar "b"
val alpha' = Tyvar "a'"
val beta' = Tyvar "b'"

(* Type-schemes *)

fun mk_tyscheme [] t = Type t
  | mk_tyscheme ((Tyvar v)::vs) t = Forall (v, mk_tyscheme vs t)
  | mk_tyscheme _ _ = raise Fail "mk_tyscheme: Invalid type-scheme."

(* Now we can construct type-schemes. For example here is a
   polymorphic function taking pairs of functions and two lists to a
   list of pairs: *)

val dmapts = mk_tyscheme [alpha, alpha', beta, beta'] 
                  (pairt (alpha --> alpha') (beta --> beta') 
                      --> listt alpha --> listt beta
                      --> pairt (listt alpha') (listt beta'));
ppts dmapts;

(* Lambda expressions with let bindings *)

fun labs (Var v) e = Abs(v,e)
  | labs _ _ = raise Fail "labs: Invalid argument"

fun llet (Var v) e1 e2 = Let((v,e1),e2)
  | llet _ _ _ = raise Fail "llet: Invalid argument"

infix @:
fun e1 @: e2 = Comb(e1,e2)

fun lambda [] e = e
  | lambda (x::xs) e = labs x (lambda xs e)

fun letbind [] e = e
  | letbind ((v,e1)::bs) e = llet v e1 (letbind bs e)

fun lapply r [] = r
  | lapply r (e::es) = lapply (r @: e) es

(* Variables *)

val x = Var "x"
val y = Var "y"
val z = Var "z"
val p = Var "p"
val f = Var "f"
val m = Var "m"
val n = Var "n"
val s = Var "s"
val i = Var "i"

(* Church numerals *)

fun num n =
  let val f = Var "f"
      val x = Var "x"
      fun iter r 0 = lambda [f,x] r
        | iter r n = iter (f @: r) (n-1)
  in
     iter x n
  end

(* Now we can construct assumptions and expressions *)

(* S ZERO = (λ n f x.n f (f x)) λ f x.x  *)

val ZERO = num 0
val S = lambda [n,f,x] (n @: f @: (f @: x));
ppts (principalts [] (S @: ZERO));

(* PRED and PRED 6 *)

val PAIR = (lambda [x, y, f] (f @: x @: y))
val FST = (lambda [p] (p @: (lambda [x, y] x)))
val SND = (lambda [p] (p @: (lambda [x, y] y)))

val G = lambda [f,p] (PAIR @: (f @: (FST @: p)) @: (FST @: p))
val PRED = lambda [n] (SND @: (n @: (G @: S) @: (PAIR @: ZERO @: ZERO)))
val SUB = lambda [m, n] (n @: PRED @: m);

ppts (principalts [] PRED);
ppts (principalts [] (PRED @: (num 6)));
ppts (principalts [] SUB);

(* The definition of PRED from Larry Paulson's lecture notes *)

val PREDp = lambda [n,f,x] (SND @: (n @: (G @: f) @: (PAIR @: x @: x)))
val SUBp = lambda [m, n] (n @: PREDp @: m);

ppts (principalts [] PREDp);
ppts (principalts [] (PREDp @: (num 6)));

ppexp SUBp;
ppts (principalts [] SUBp);

(* let i=λx.x in i i *)

val polylet = letbind [(i,lambda [x] x)] (i @: i);
ppexp polylet;
ppts (principalts [] polylet);

(* map *)
val condts = mk_tyscheme [alpha] (boolt --> alpha --> alpha --> alpha)
val fixts = mk_tyscheme [alpha] ((alpha --> alpha) --> alpha)

val nullts = mk_tyscheme [alpha] (listt alpha --> boolt)
val nilts = mk_tyscheme [alpha] (listt alpha)
val consts = mk_tyscheme [alpha] (alpha --> listt alpha --> listt alpha)
val hdts = mk_tyscheme [alpha] (listt alpha --> alpha)
val tlts = mk_tyscheme [alpha] (listt alpha --> listt alpha)

val pairts = mk_tyscheme [alpha, beta] (alpha --> beta --> pairt alpha beta)
val fstts = mk_tyscheme [alpha, beta] (pairt alpha beta --> alpha)
val sndts = mk_tyscheme [alpha, beta] (pairt alpha beta --> beta)

val bool_assums = [("true",Type(boolt)),("false",Type(boolt)),("cond",condts)]
val pair_assums = [("pair",pairts),("fst",fstts),("snd",sndts)]
val fix_assums = [("fix",fixts)]
val list_assums = [("null",nullts),("nil",nilts),
                   ("cons",consts),("hd",hdts),("tl",tlts)]

(* let map = (fix (λ map f s.
                 (cond (null s) nil
                       (cons (f (hd s)) (map f (tl s)))))) in map *)

val assums = bool_assums@fix_assums@list_assums

val map' = Var "map"
val fix = Var "fix"
val null' = Var "null"
val nil' = Var "nil"
val cond = Var "cond"
val cons = Var "cons"
val hd' = Var "hd"
val tl' = Var "tl"

val mapdef = 
   letbind [(map',
           (fix @: (lambda [map', f, s] 
                         (cond @: (null' @: s)
                               @: nil' 
                               @: (cons @: (f @: (hd' @: s))
                                       @: (map' @: f @: (tl' @: s)))))))] 
            map';

ppassums assums;
ppexp mapdef;
val mapdefts = principalts assums mapdef;
ppts mapdefts;

(* Mairson's expression in ML
let fun pair x y = fn z => z x y 
    val x1 = fn y => pair y y 
    val x2 = fn y => x1 (x1 y)
    val x3 = fn y => x2 (x2 y)
    val x4 = fn y => x3 (x3 y)
    val x5 = fn y => x4 (x4 y)
in
   x5 (fn z => z)
end
*)

val x1 = Var "x1"
val x2 = Var "x2"
val x3 = Var "x3"
val x4 = Var "x4"
val x5 = Var "x5"
val pair = Var "pair"

val mairson = 
   letbind 
     [(pair,lambda [x,y,z] (z @: x @: y)),
      (x1,lambda [y] (pair @: y @: y)),
      (x2,lambda [y] (x1 @: (x1 @: y))),
      (x3,lambda [y] (x2 @: (x2 @: y))),
      (x4,lambda [y] (x3 @: (x3 @: y)))
 ] (x4 @: (lambda [x] x));

ppts (principalts [] mairson);

(*
val mairson = 
   letbind 
     [(pair,lambda [x,y,z] (z @: x @: y)),
      (x1,lambda [y] (pair @: y @: y)),
      (x2,lambda [y] (x1 @: (x1 @: y))),
      (x3,lambda [y] (x2 @: (x2 @: y))),
      (x4,lambda [y] (x3 @: (x3 @: y))),
      (x5,lambda [y] (x4 @: (x4 @: y)))
 ] (x5 @: (lambda [x] x));

principalts [] mairson;
*)

(* handle expected exceptions *)

exception TestFail
fun expect_Unify se f =
   (ignore(f ())) handle Unify s => if se = s then () else raise TestFail

(* omega *)

val omegaexp = Let(("omega",Abs ("x",Comb(Var "x",Var "x"))),Var "omega")
val omegadef = fn () => 
    principalts [] omegaexp;
expect_Unify "Occurs" omegadef;

(* Y *)

val r = Abs("x",Comb(Var "f",Comb(Var "x",Var "x")))
val ydef = fn () => principalts [] (Let(("Y",Abs ("f",Comb(r,r))),Var "Y"));
expect_Unify "Occurs" ydef;

(* Church numerals *)
val nassums = [];

val cn_zerodef = Abs("f",Abs("x",Var "x"));
ppassums nassums;
ppexp cn_zerodef;
val cn_zero = principalts [] cn_zerodef;
ppts cn_zero;

val cn_onedef = Abs("f",Abs("x",Comb(Var "f", Var "x")));
ppassums nassums;
ppexp cn_onedef;
val cn_one = principalts [] cn_onedef;
ppts cn_one;

val cn_twodef = Abs("f",Abs("x",Comb(Var "f",Comb(Var "f",Var "x"))));
ppassums nassums;
ppexp cn_twodef;
val cn_two = principalts [] cn_twodef;
ppts cn_two;

ppts cn_zero;
ppts cn_one;
ppts cn_two;

(* Church numerals in SML *)

fn f => fn x => x;
fn f => fn x => f x;
fn f => fn x => f (f x)
