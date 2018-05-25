module Chapter3

import Data.Vect

%default total

namespace List
  allLengths : List String -> List Nat
  allLengths [] = []
  allLengths (x :: xs) = length x :: allLengths xs

namespace Vect
  allLengths : Vect n String -> Vect n Nat
  allLengths [] = []
  allLengths (x :: xs) = length x :: allLengths xs

insert : Ord elem => (x : elem) -> (xsSorted : Vect len elem) -> Vect (S len) elem
insert x [] = [x]
insert x (y :: xs) = if x < y then x :: y :: xs
                              else y :: insert x xs

insSort : Ord elem => Vect n elem -> Vect n elem
insSort [] = []
insSort (x :: xs) =
  let xsSorted = insSort xs in
  insert x xsSorted

sortEg1 : insSort [1, 3, 2, 9, 7, 6, 4, 5, 8] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
sortEg1 = Refl

myLength : List a -> Nat
myLength [] = 0
myLength (x :: xs) = 1 + myLength xs

myReverse : List a -> List a
myReverse [] = []
myReverse (x :: xs) = reverse xs ++ [x]

namespace List
  myMap : (a -> b) -> List a -> List b
  myMap f [] = []
  myMap f (x :: xs) = f x :: myMap f xs

namespace Vect
  myMap : (a -> b) -> Vect n a -> Vect n b
  myMap f [] = []
  myMap f (x :: xs) = f x :: myMap f xs


--
-- Matrices (and Vectors)
--

v : Vect 3 (Vect 4 Int)
v = [ [1,  2,  3,  4]
    , [5,  6,  7,  8]
    , [9, 10, 11, 12] ]

createEmpties : Vect n (Vect 0 elem)
createEmpties = replicate _ []

transposeHelper : (x : Vect n elem) ->
  (xsTrans : Vect n (Vect len elem)) ->
  Vect n (Vect (S len) elem)
transposeHelper x xsTrans = zipWith (::) x xsTrans

transposeMat : Vect m (Vect n elem) -> Vect n (Vect m elem)
transposeMat [] = createEmpties
transposeMat (x :: xs) =
  let xsTrans = transposeMat xs
  in transposeHelper x xsTrans

transposeMatEg1 : transposeMat [[1,2], [3,4], [5,6]] = [[1, 3, 5], [2, 4, 6]]
transposeMatEg1 = Refl

addVector : Num a => (x : Vect m a) -> (y : Vect m a) -> Vect m a
addVector [] [] = []
addVector (x :: xs) (y :: ys) = x + y :: addVector xs ys

addMatrix : Num a => Vect n (Vect m a) -> Vect n (Vect m a) -> Vect n (Vect m a)
addMatrix [] [] = []
addMatrix (x :: xs) (y :: ys) = addVector x y :: addMatrix xs ys

addMatrixEg1 : addMatrix [[1,2], [3,4]] [[5,6], [7,8]] = [[6, 8], [10, 12]]
addMatrixEg1 = Refl

{-
  [[1, 2],
   [3, 4],
   [5, 6]]
  [[7, 11],
   [8, 12],
   [9, 13],
   [10, 14]]
-}

{-
The value in row x, column y in the result is the sum of the product of
corresponding elements in row x of the left input, and column y of the
right input.

2x1 x 1x2 = 2x2

| 1 | | 3 4 | = | 3 4 |
| 2 |           | 6 8 |

| 1 | | 3 | = | 3 4 |
| 2 | | 4 |   | 6 8 |

-}

sumProducts : Num numType => Vect m numType -> Vect m numType -> numType
sumProducts [] [] = 0
sumProducts (x :: xs) (y :: ys) = (x * y) + sumProducts xs ys

easyMulMatrix : Num numType =>
  (xs : Vect n (Vect m numType)) ->
  (ysTrans : Vect p (Vect m numType)) ->
  Vect n (Vect p numType)
easyMulMatrix [] ysTrans = []
easyMulMatrix (x :: xs) ysTrans =
  let sp = map (sumProducts x) ysTrans
  in sp :: easyMulMatrix xs ysTrans

mulMatrix : Num numType =>
  Vect n (Vect m numType) ->
  Vect m (Vect p numType) ->
  Vect n (Vect p numType)
mulMatrix xs ys = let ysTrans = transposeMat ys in easyMulMatrix xs ysTrans

mulMatrixEg1 :
  mulMatrix
    [[1, 2],
     [3, 4],
     [5, 6]]
    [[ 7,  8,  9, 10],
     [11, 12, 13, 14]] =
    [[29, 32, 35, 38],
    [65, 72, 79, 86],
    [101, 112, 123, 134]]
mulMatrixEg1 = Refl

append : (elem : Type) -> (n : Nat) -> (m : Nat) ->
         Vect n elem -> Vect m elem -> Vect (n + m) elem
append elem Z m [] ys = ys
append elem (S k) m (x :: xs) ys = x :: append elem k m xs ys
