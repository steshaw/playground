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

exactLength1 : (len : Nat) -> (v : Vect m a) -> Maybe (Vect len a)
exactLength1 len v {m} =
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

--
-- 8.2.5 Appending vectors, revisited
--

append1 : Vect n elem -> Vect m elem -> Vect (n + m) elem
append1 [] ys = ys
append1 (x :: xs) ys = x :: append1 xs ys


append2 : Vect n elem -> Vect m elem -> Vect (m + n) elem
append2 [] ys = nilProof ys
  where
    nilProof : Vect m elem -> Vect (plus m 0) elem
    nilProof xs {m} = rewrite plusZeroRightNeutral m in xs
append2 (x :: xs) ys = consProof $ x :: (append2 xs ys)
  where
  consProof : Vect (S (m + len)) elem -> Vect (plus m (S len)) elem
  consProof xs {m} {len} =
    rewrite sym (plusSuccRightSucc m len) in xs

-- Exercises

-- Using plusZeroRightNeutral and plusSuccRightSucc.
--
-- plusZeroRightNeutral : (left : Nat) -> plus left 0 = left
-- plusSuccRightSucc : (left : Nat) -> (right : Nat) -> S (left + right) = left + S right
--
myPlusCommutes : (n : Nat) -> (m : Nat) -> n + m = m + n
myPlusCommutes Z m = rewrite plusZeroRightNeutral m in Refl
myPlusCommutes (S k) m =
  rewrite myPlusCommutes k m in
  rewrite plusSuccRightSucc m k in
  Refl

myReverse3 : Vect n a -> Vect n a
myReverse3 xs = loop [] xs
  where
  loop : Vect n a -> Vect m a -> Vect (n + m) a
  loop acc [] = nilProof acc
    where
    nilProof : Vect n a -> Vect (plus n 0) a
    nilProof xs {n} = rewrite plusZeroRightNeutral n in xs
  loop acc (x :: ys) = consProof (loop (x :: acc) ys)
    where
    consProof : Vect (S (m + len)) elem -> Vect (plus m (S len)) elem
    consProof xs {m} {len} = rewrite sym (plusSuccRightSucc m len) in xs

--
-- 8.3 The empty type and decidability
--

data Void2 : Type where

twoPlusTwoNotFive : 2 + 2 = 5 -> Void
twoPlusTwoNotFive Refl impossible

partial
loop : Void2
loop = loop

valueNotSuc : (n : Nat) -> n = S n -> Void
valueNotSuc _ Refl impossible

void : Void -> a
void _ impossible

zeroNotSucc : (0 = S k) -> Void
zeroNotSucc Refl impossible

succNotZero : (S k = 0) -> Void
succNotZero Refl impossible

noRec : (contra : (k = j) -> Void) -> (S k = S j) -> Void
noRec contra Refl = contra Refl

checkEqNat5 : (n1 : Nat) -> (n2 : Nat) -> Dec (n1 = n2)
checkEqNat5 Z Z = Yes Refl
checkEqNat5 Z (S k) = No zeroNotSucc
checkEqNat5 (S k) Z = No succNotZero
checkEqNat5 (S k) (S j) =
  case checkEqNat5 k j of
    Yes prf => Yes (cong prf)
    No contra => No (noRec contra)

--
-- 8.3.3 DecEq: an interface for decidable equality
--

interface DecEq2 where
  decEq2 : (a : t) -> (b : t) -> Dec (a = b)

exactLength2 : (len : Nat) -> (input : Vect m a) -> Maybe (Vect len a)
exactLength2 len input {m} =
  case decEq len m of
    Yes Refl => pure input
    No contra => Nothing

--
-- Exercises
--

headUnequal :
  DecEq a =>
  {xs : Vect n a} ->
  {ys : Vect n a} ->
  (contra : (x = y) -> Void) ->
  ((x :: xs) = (y :: ys)) ->
  Void
headUnequal contra Refl = contra Refl

tailUnequal :
  DecEq a =>
  {xs : Vect n a} ->
  {ys : Vect n a} ->
  (contra : (xs = ys) -> Void) ->
  ((x :: xs) = (y :: ys)) ->
  Void
tailUnequal contra Refl = contra Refl

-- DecEq a => DecEq (Vect n a) where
