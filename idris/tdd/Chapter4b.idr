module Chapter4b

import Data.Vect

%default total

tryIndex : Integer -> Vect n a -> Maybe a
tryIndex x xs {n} = case integerToFin x n of
                      Nothing => Nothing
                      (Just x) => Just $ Vect.index x xs

vectTake : (m : Nat) -> Vect (m + n) a -> Vect m a
vectTake Z xs = []
vectTake (S k) (x :: xs) = x :: vectTake k xs

vectTakeEg0 : vectTake 0 [1,2,3,4,5,6,7] = []
vectTakeEg0 = Refl

vectTakeEg1 : vectTake 1 [1,2,3,4,5,6,7] = [1]
vectTakeEg1 = Refl

vectTakeEg2 : vectTake 2 [1,2,3,4,5,6,7] = [1, 2]
vectTakeEg2 = Refl

-- Things don't work out nicely when trying "Vect (n + m)"
{-
vectTake2 : (m : Nat) -> Vect (n + m) a -> Vect m a
vectTake2 Z xs = []
vectTake2 (S _) [] impossible
vectTake2 (S _) (_ :: _) impossible
-}

sumEntries : Num a => (pos : Integer) -> Vect n a -> Vect n a -> Maybe a
sumEntries pos {n} xs ys =
  case integerToFin pos n of
    Nothing => Nothing
    (Just i) => Just (index i xs + index i ys)

sumEntriesEg1 : sumEntries 2 [1,2,3,4] [5,6,7,8] = Just 10
sumEntriesEg1 = Refl

sumEntriesEg2 : sumEntries 4 [1,2,3,4] [5,6,7,8] = Nothing
sumEntriesEg2 = Refl

sumEntriesEg3 : sumEntries 0 [1,2,3,4] [5,6,7,8] = Just 6
sumEntriesEg3 = Refl

sumEntriesEg4 : sumEntries (-3) [1,2,3,4] [5,6,7,8] = Nothing
sumEntriesEg4 = Refl
