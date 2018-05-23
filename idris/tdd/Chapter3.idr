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
transposeHelper [] [] = []
transposeHelper (x :: xs) (y :: ys) = (x :: y) :: transposeHelper xs ys

transposeMat : Vect m (Vect n elem) -> Vect n (Vect m elem)
transposeMat [] = createEmpties
transposeMat (x :: xs) =
  let xsTrans = transposeMat xs
  in transposeHelper x xsTrans
