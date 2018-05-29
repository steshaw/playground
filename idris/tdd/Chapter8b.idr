|||
||| 8.3.3 DecEq: an interface for decidable equality
|||
module Chapter8b

%default total

data Vect : Nat -> Type -> Type where
  Nil : Vect Z a
  (::) : a -> Vect k a -> Vect (S k) a

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

DecEq a => DecEq (Vect n a) where
  decEq [] [] = Yes Refl
  decEq (x :: xs) (y :: ys) =
    case decEq x y of
      Yes Refl => case decEq xs ys of
        Yes Refl => Yes Refl
        (No contra) => No (tailUnequal contra)
      No contra => No (headUnequal contra)
