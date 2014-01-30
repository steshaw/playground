module errorInterp

ValT : Type
ValT = Int

data Expr
  = Var String
  | Val ValT
  | Add Expr Expr

EnvT : Type
EnvT = List (String, ValT)

data Eval : Type -> Type where
  MkEval : {a : Type} -> (EnvT -> Maybe a) -> Eval a

fetch : String -> EnvT -> Maybe ValT
fetch id Nil              = Nothing
fetch id ((var, val)::xs) =
  if (id == var) then (Just val) else (fetch id xs)

fetchE : String -> Eval ValT
fetchE id = MkEval (\env => fetch id env)

instance Functor Eval where
  map f (MkEval g) = MkEval (\env => map f (g env))

instance Applicative Eval where
  pure val = MkEval (\env => Just val)

  (MkEval f) <$> (MkEval g) = MkEval (\env => f env <$> g env)

eval : Expr -> Eval ValT
eval (Var var) = fetchE var
eval (Val val) = [| val |]
eval (Add x y) = [| eval x + eval y |]

env : EnvT
env = [("a", 1), ("b", 2), ("c", 3)]

exp1 : Expr
exp1 = Add (Var "a") (Val 1)

exp2 : Expr
exp2 = Add (Var "a") (Var "b")

exp3 : Expr
exp3 = Var "c"

exp4 : Expr
exp4 = Val 99

exp5 : Expr
exp5 = Add (Add exp1 exp2) (Val 3)

exp6 : Expr
exp6 = Var "fred"

exp7 : Expr
exp7 = Add (Add (Add (Add (Var "c") exp6) (Var "a")) (Val 3)) (Var "b")
