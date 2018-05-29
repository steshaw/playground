|||
|||  Equality: expressing relationships between data
|||
||| Revisiting Chapter 8 again. Found it pretty hard going,
||| needing to peek at solutions to complete the exercises.
|||

module Chapter8c

data Vect : Nat -> Type -> Type where
  Nil :Vect Z a
  (::) : a -> Vect k a -> Vect (S k) a

exactLength : (len : Nat) -> (input : Vect m a) -> Maybe (Vect len a)
exactLength len input {m} =
  case len == m of
    False => Nothing
    True => ?exactLength_rhs_2 -- <-- fails here because `==` doesn't retain
                               -- a relationship between `len` and `m`.

data EqNat : (n1 : Nat) -> (n2 : Nat) -> Type where
  Same : (n : Nat) -> EqNat n n

%name EqNat eq, eq1, eq2, eq3

sameS : EqNat k j -> EqNat (S k) (S j)
sameS (Same k) = Same (S k)

checkEqNat : (n1 : Nat) -> (n2 : Nat) -> Maybe (EqNat n1 n2)
checkEqNat Z Z = Just (Same 0)
checkEqNat Z (S k) = Nothing
checkEqNat (S k) Z = Nothing
checkEqNat (S k) (S j) =
  case checkEqNat k j of
    Nothing => Nothing
    (Just x) => pure (sameS x)
