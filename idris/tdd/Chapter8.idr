|||
||| Equality as a _type_.
|||
module Chapter8

import Data.Vect

%default total

{-
namespace MyVect
  data Vect : Nat -> Type -> Type where
    Nil : MyVect.Vect Z a
    (::) : a -> MyVect.Vect k a -> MyVect.Vect (S k) a
-}

data EqNat : (a : Nat) -> (b : Nat) -> Type where
  Same : (a : Nat) -> EqNat a a

sameS : (eq : EqNat k j) -> EqNat (S k) (S j)
sameS {k = k} {j = k} (Same k) = Same (S k)

checkEqNat : (a : Nat) -> (b : Nat) -> Maybe (EqNat a b)
checkEqNat Z Z = Just (Same 0)
checkEqNat Z (S k) = Nothing
checkEqNat (S k) Z = Nothing
checkEqNat (S k) (S j) = case checkEqNat k j of
                              Nothing => Nothing
                              Just eq => Just (sameS eq)

exactLength : (len : Nat) -> (v : Vect m a) -> Maybe (Vect len a)
exactLength len v {m} =
  case checkEqNat len m of
    Nothing => empty
    Just (Same _) => pure v

||| `checkEqNat` without using `sameS`.
checkEqNat2 : (a : Nat) -> (b : Nat) -> Maybe (EqNat a b)
checkEqNat2 Z Z = Just (Same 0)
checkEqNat2 Z (S k) = Nothing
checkEqNat2 (S k) Z = Nothing
checkEqNat2 (S k) (S j) = do
  (Same j) <- checkEqNat2 k j
  pure (Same (S j))

data Equal : (a : t) -> (b : t) -> Type where
  Reflexive : (a : t) -> Equal a a

congruence : {f : a -> b} -> (eq : Equal k j) -> Equal (f k) (f j)
congruence {f} (Reflexive k) = Reflexive (f k)

||| Version of `checkEqNat` using the generic equality, `Equal`.
checkEqNat3 : (a : Nat) -> (b : Nat) -> Maybe (Equal a b)
checkEqNat3 Z Z = Just (Reflexive 0)
checkEqNat3 Z (S k) = Nothing
checkEqNat3 (S k) Z = Nothing
checkEqNat3 (S k) (S j) = do
  eq <- checkEqNat3 k j
  pure (congruence eq)

||| Version of `checkEqNat` using Idris' built-in equality type, (=).
checkEqNat4 : (num1 : Nat) -> (num2 : Nat) -> Maybe (num1 = num2)
checkEqNat4 Z Z = pure Refl
checkEqNat4 Z (S k) = Nothing
checkEqNat4 (S k) Z = Nothing
checkEqNat4 (S k) (S j) = do
  prf <- checkEqNat4 k j
  pure (cong prf)

--
-- Exercises
--

sameCons : {xs : List a} -> {ys : List a} -> xs = ys -> x :: xs = x :: ys
sameCons = cong

same_lists :
  {xs : List a} ->
  {ys : List a} ->
  x = y ->
  xs = ys ->
  x :: xs = y :: ys
same_lists Refl prf2 = cong prf2

data Equal3 : (a : t) -> (b : t) -> (c : t) -> Type where
  Reflexive3 : Equal3 a a a

|||
||| if x y z are all equal then the successors of x y z are equal too.
|||
allSameS : (x, y, z : Nat) -> Equal3 x y z -> Equal3 (S x) (S y) (S z)
allSameS z z z Reflexive3 = Reflexive3 {a = S z}

myReverse : Vect n elem -> Vect n elem
myReverse [] = []
myReverse {n = S k} (x :: xs) =
  let result = myReverse xs ++ [x]
  in rewrite plusCommutative 1 k
  in result

myReverse2 : Vect n elem -> Vect n elem
myReverse2 [] = []
myReverse2 (x :: xs) = proof1 (myReverse2 xs ++ [x])
  where
    proof1 : Vect (len + 1) elem -> Vect (S len) elem
    proof1 {len} xs = rewrite (plusCommutative 1 len) in xs
