|||
||| Equality: expressing relationships between data
|||
||| Revisiting Chapter 8 again. Found it pretty hard going,
||| needing to peek at solutions to complete the exercises.
|||

module Chapter8c

--
-- 8.1 Guaranteeing equivalence of data with equality types
--

data Vect : Nat -> Type -> Type where
  Nil :Vect Z a
  (::) : a -> Vect k a -> Vect (S k) a

exactLength1 : (len : Nat) -> (input : Vect m a) -> Maybe (Vect len a)
exactLength1 len input {m} =
  case len == m of
    False => Nothing
    True => ?exactLength_rhs_2 -- <-- fails here because `==` doesn't retain
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
