|||
||| # 8. Equality: expressing relationships between data
|||
||| Revisiting Chapter 8 again. Found it pretty hard going,
||| needing to peek at solutions to complete the exercises.
|||

module Chapter8c

--
-- ## 8.1 Guaranteeing equivalence of data with equality types
--

data Vect : Nat -> Type -> Type where
  Nil :Vect Z a
  (::) : a -> Vect k a -> Vect (S k) a

%name Vect xs, ys, zs

exactLength1 : (len : Nat) -> (input : Vect m a) -> Maybe (Vect len a)
exactLength1 len input {m} =
  case len == m of
    False => Nothing
    True => ?failsHere  -- <-- fails here because `==` doesn't retain
                        -- a relationship between `len` and `m`.

data EqNat : (n1 : Nat) -> (n2 : Nat) -> Type where
  Same : (n : Nat) -> EqNat n n

%name EqNat eq, eq1, eq2, eq3

sameS1 : EqNat k j -> EqNat (S k) (S j)
sameS1 (Same k) = Same (S k)

sameS2 : (k : Nat) -> (j : Nat) -> (eq : EqNat k j) -> EqNat (S k) (S j)
sameS2 j j (Same j) = Same (S j)

checkEqNat0 : (n1 : Nat) -> (n2 : Nat) -> Maybe (EqNat n1 n2)
checkEqNat0 Z Z = Just (Same 0)
checkEqNat0 Z (S k) = Nothing
checkEqNat0 (S k) Z = Nothing
checkEqNat0 (S k) (S j) =
  case checkEqNat0 k j of
    Nothing => Nothing
    (Just eq) => pure (sameS1 eq)

checkEqNat1 : (n1 : Nat) -> (n2 : Nat) -> Maybe (EqNat n1 n2)
checkEqNat1 Z Z = Just (Same 0)
checkEqNat1 Z (S k) = Nothing
checkEqNat1 (S k) Z = Nothing
checkEqNat1 (S k) (S j) =
  case checkEqNat1 k j of
    Nothing => Nothing
    Just eq => pure (sameS2 k j eq)

exactLength2 : (len : Nat) -> (input : Vect m a) -> Maybe (Vect len a)
exactLength2 len input {m} = do
  Same _ <- checkEqNat0 len m
  pure input

-- ### 8.1.6 Equality in general: the = type

data Equal : a -> b -> Type where
  Reflexive : a `Equal` a

checkEqNat2 : (n1 : Nat) -> (n2 : Nat) -> Maybe (n1 = n2)
checkEqNat2 Z Z = Just Refl
checkEqNat2 Z (S k) = Nothing
checkEqNat2 (S k) Z = Nothing
checkEqNat2 (S k) (S j) =
  case checkEqNat2 k j of
    Nothing => Nothing
    Just prf => pure (cong prf)

checkEqNat3 : (n1 : Nat) -> (n2 : Nat) -> Maybe (n1 = n2)
checkEqNat3 Z Z = Just Refl
checkEqNat3 Z (S k) = Nothing
checkEqNat3 (S k) Z = Nothing
checkEqNat3 (S k) (S j) =
  case checkEqNat3 k j of
    Nothing => Nothing
    Just Refl => pure Refl

-- "Golfing" the maybe failure here doesn't work.
{-
checkEqNat4 : (n1 : Nat) -> (n2 : Nat) -> Maybe (n1 = n2)
checkEqNat4 Z Z = Just Refl
checkEqNat4 Z (S k) = Nothing
checkEqNat4 (S k) Z = Nothing
checkEqNat4 (S k) (S j) = do
  Just Refl <- checkEqNat4 k j
  pure Refl
-}

-- Exercises

sameCons : {x : a} -> {xs : List a} -> {ys : List a} -> xs = ys -> x :: xs = x :: ys
sameCons Refl = Refl

sameLists : {xs : List a} -> {ys : List a} -> x = y -> xs = ys -> x :: xs = y :: ys
sameLists Refl Refl = Refl

data ThreeEq : (a : t) -> (b : t) -> (c : t) -> Type where
  MkThreeEq : ThreeEq a a a

%name ThreeEq eq, eq1, eq2, eq3

allSameS : (x, y, z : Nat) -> ThreeEq x y z -> ThreeEq (S x) (S y) (S z)
allSameS z z z MkThreeEq = MkThreeEq

--
-- ## 8.2 Equality in practice: types and reasoning
--

(++) : Vect n elem -> Vect m elem -> Vect (n + m) elem
(++) [] ys = ys
(++) (x :: xs) ys = x :: (xs ++ ys)

-- Trying to avoid `rewrite` by using pattern matching.
{-
myReverse : Vect n elem -> Vect n elem
myReverse [] = []
myReverse (x :: xs) = helper x xs
  where
  helper : elem -> Vect k elem -> Vect (S k) elem
  helper x xs {k} =
    case plusCommutative k 1 of
      case_val => ?something (myReverse xs ++ [x])
-}

myReverse1 : Vect n elem -> Vect n elem
myReverse1 [] = []
myReverse1 {n = S k} (x :: xs) = -- <-- No idea where `n = S k` comes from here.
  let result = myReverse1 xs ++ [x]
  in rewrite plusCommutative 1 k in result

myReverse2 : Vect n elem -> Vect n elem
myReverse2 [] {n = Z} = []
myReverse2 (x :: xs) {n = (S k)} =
  rewrite plusCommutative 1 k
  in (myReverse2 xs ++ [x])

myReverse3 : Vect n elem -> Vect n elem
myReverse3 [] = []
myReverse3 (x :: xs) = reverseProof (myReverse3 xs ++ [x])
  where
  reverseProof : Vect (k + 1) elem -> Vect (S k) elem
  reverseProof result {k} = rewrite plusCommutative 1 k in result

--
-- ### 8.2.5 Appending vectors, revisited
--

append1Nil : (ys : Vect m elem) -> Vect (plus m 0) elem
append1Nil ys {m} = rewrite plusZeroRightNeutral m in ys

append1Cons : Vect (S (m + k)) elem -> Vect (plus m (S k)) elem
append1Cons xs {m} {k} = rewrite sym (plusSuccRightSucc m k) in xs

append1 : Vect n elem -> Vect m elem -> Vect (m + n) elem
append1 [] ys = append1Nil ys
append1 (x :: xs) ys = append1Cons (x :: append1 xs ys)

--
-- Exercises
--

myPlusZeroRightNeutral : (left : Nat) -> left + 0 = left
myPlusZeroRightNeutral Z = Refl
myPlusZeroRightNeutral (S k) =
  let r = myPlusZeroRightNeutral k
  in cong r

myPlusSuccRightSucc : (left : Nat) -> (right : Nat) -> S (left + right) = left + S right
myPlusSuccRightSucc Z right = Refl
myPlusSuccRightSucc (S k) m =
  let r = myPlusSuccRightSucc k m
  in cong r

myPlusCommutes : (n : Nat) -> (m : Nat) -> n + m = m + n
myPlusCommutes Z m =     rewrite (plusZeroRightNeutral m) in Refl {x = m}
myPlusCommutes (S k) m =
  let r = myPlusCommutes k m
  in rewrite sym (plusSuccRightSucc m k) in cong r

reverseProofNil : (acc : Vect m a) -> Vect (plus m 0) a
reverseProofNil acc {m} = rewrite myPlusZeroRightNeutral m in acc

reverseProofCons :  Vect ((S m) + k) a -> Vect (plus m (S k)) a
reverseProofCons xs {m} {k} = rewrite sym (myPlusSuccRightSucc m k) in xs

myReverse4 : Vect n a -> Vect n a
myReverse4 xs = reverse' [] xs
  where
  reverse' : Vect m a -> Vect n a -> Vect (m + n) a
  reverse' acc [] = reverseProofNil acc
  reverse' acc (x :: xs) = reverseProofCons (reverse' (x :: acc) xs)

--
-- ## 8.3 The empty type and decidability
--
