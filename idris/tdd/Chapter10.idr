|||
||| # 10: Views: extending pattern matching
|||
module Main

import Data.List.Views
import Data.Nat.Views
import Data.Vect
import Data.Vect.Views

%default total

---
--- ## 10.1 Defining and using views
---

-- This does not work as `(xs ++ [x])` is not a valid pattern here.
{-
describeListEnd : List Int -> String
describeListEnd [] = "Empty"
describeListEnd (xs ++ [x]) = "Non-empty, initial portion = " ++ show xs
-}

data ListLast : List a -> Type where
  Empty : ListLast []
  NonEmpty : (xs : List a) -> (x : a) -> ListLast (xs ++ [x])

listLast : (xs : List a) -> ListLast xs
listLast [] = Empty
listLast (x :: xs) = case listLast xs of
                          Empty => NonEmpty [] x
                          NonEmpty ys y => NonEmpty (x :: ys) y

describeHelper : (input : List Int) -> (form : ListLast input) -> String
describeHelper [] Empty = "Empty"
describeHelper (xs ++ [x]) (NonEmpty xs x) = "Non-empty, initial portion = " ++ show xs

describeListEnd : List Int -> String
describeListEnd xs = describeHelper xs (listLast xs)

describeListEnd2 : List Int -> String
describeListEnd2 xs with (listLast xs)
  describeListEnd2 [] | Empty = "Empty"
  describeListEnd2 (ys ++ [x]) | (NonEmpty ys x) =
    "Non-empty, initial portion = " ++ show ys

partial
myReverse1 : List a -> List a
myReverse1 xs with (listLast xs)
  myReverse1 [] | Empty = []
  myReverse1 (ys ++ [x]) | (NonEmpty ys x) = x :: myReverse1 ys

-- This does not work since (++) isn't a data contructor.
{-
mergeSort : Ord a => List a -> List a
mergeSort [] = x
mergeSort [x] = [x]
mergeSort (lefts ++ rights) = merge (mergeSort lefts) (mergeSort rights)
-}

data SplitList : List a -> Type where
  SplitNil : SplitList []
  SplitOne : SplitList [x]
  SplitPair : (lefts : List a) -> (rights : List a) ->
              SplitList (lefts ++ rights)

splitList : (input : List a) -> SplitList input
splitList input = splitListHelp input input
  where
  splitListHelp : List a -> (input : List a) -> SplitList input
  splitListHelp _ [] = SplitNil
  splitListHelp _ [x] = SplitOne
  splitListHelp (_ :: _ :: counter) (item :: items) =
    case splitListHelp counter items of
      SplitNil => SplitOne
      SplitOne {x} => SplitPair [item] [x]
      SplitPair lefts rights => SplitPair (item :: lefts) rights
  splitListHelp _ items = SplitPair [] items

partial
mergeSort1 : Ord a => List a -> List a
mergeSort1 xs with (splitList xs)
  mergeSort1 [] | SplitNil = []
  mergeSort1 [x] | SplitOne = [x]
  mergeSort1 (lefts ++ rights) | (SplitPair lefts rights) =
    merge (mergeSort1 lefts) (mergeSort1 rights)

--
-- Exercises
--

data TakeN : List a -> Type where
  Fewer : TakeN xs
  Exact : (xs : List a) -> TakeN (xs ++ rest)

takeN : (n : Nat) -> (xs : List a) -> TakeN xs
takeN Z xs = Exact []
takeN (S k) [] = Fewer
takeN (S k) (x :: xs) with (takeN k xs)
  takeN (S k) (x :: xs) | Fewer = Fewer
  takeN (S k) (x :: (ys ++ rest)) | (Exact ys) = Exact (x :: ys)

partial
groupByN1 : (n : Nat) -> (xs : List a) -> List (List a)
groupByN1 n xs with (takeN n xs)
  groupByN1 n xs | Fewer = [xs]
  groupByN1 n (n_xs ++ rest) | (Exact n_xs) = n_xs :: groupByN1 n rest

partial
halves : List a -> (List a, List a)
halves xs =
  let l = length xs `div` 2 in
  case takeN l xs of
    Fewer => ([], [])
    Exact xs {rest} => (xs, rest)

--
-- ## 10.2 Recursive views: termination and efficiency
--

data Snoc1List ty
  = Snoc1Nil
  | Snoc1 (Snoc1List ty) ty

%name Snoc1List xs, ys, zs

reverseSnoc1 : Snoc1List ty -> List ty
reverseSnoc1 Snoc1Nil = []
reverseSnoc1 (Snoc1 xs x) = x :: reverseSnoc1 xs

data Snoc2List : List a -> Type where
  Snoc2Nil : Snoc2List []
  Snoc2 : (rec : Snoc2List xs) -> Snoc2List (xs ++ [x])

%name Snoc2List xs, ys, zs

snoc2ListHelp :
  (snoc : Snoc2List input) ->
  (rest : List a) ->
  Snoc2List (input ++ rest)
snoc2ListHelp {input} snoc [] =
  rewrite appendNilRightNeutral input in snoc
snoc2ListHelp {input} snoc (x :: xs) =
  rewrite appendAssociative input [x] xs in
  snoc2ListHelp (Snoc2 snoc {x}) xs

snoc2List : (xs : List a) -> Snoc2List xs
snoc2List xs = snoc2ListHelp Snoc2Nil xs

myReverseHelper : (input : List a) -> Snoc2List input -> List a
myReverseHelper [] Snoc2Nil = []
myReverseHelper (xs ++ [x]) (Snoc2 rec) = x :: myReverseHelper xs rec

myReverse2 : List a -> List a
myReverse2 input = myReverseHelper input (snoc2List input)

myReverse3 : List a -> List a
myReverse3 xs with (snoc2List xs)
  myReverse3 [] | Snoc2Nil = []
  myReverse3 (ys ++ [x]) | (Snoc2 rec) = x :: myReverse3 ys | rec

isSuffix : Eq a => List a -> List a -> Bool
isSuffix xs ys with (snoc2List xs)
  isSuffix [] ys | Snoc2Nil = True
  isSuffix (xs ++ [x]) ys | (Snoc2 xsrec) with (snoc2List ys)
    isSuffix (xs ++ [x]) [] | (Snoc2 xsrec) | Snoc2Nil = False
    isSuffix (xs ++ [x]) (ys ++ [y]) | (Snoc2 xsrec) | (Snoc2 ysrec) =
      (x == y) && isSuffix xs xs | xsrec | ysrec

{-
data SplitRec : List a -> Type where
  SplitRecNil : SplitRec []
  SplitRecOne : SplitRec [x]
  SplitRecPair : (lrec : SplitRec lefts) -> (rrec : SplitRec rights) ->
                 SplitRec (lefts ++ rights)

splitRec : (xs : List a) -> SplitRec xs
splitRec xs = ?splitRec_rhs
-}

mergeSort2 : Ord a => List a -> List a
mergeSort2 xs with (splitRec xs)
  mergeSort2 [] | SplitRecNil = []
  mergeSort2 [x] | SplitRecOne = [x]
  mergeSort2 (lefts ++ rights) | (SplitRecPair lrec rrec) =
    merge (mergeSort2 lefts | lrec)
          (mergeSort2 rights | rrec)

--
-- Exercises
--

equalSuffix : Eq a => List a -> List a -> List a
equalSuffix xs ys with (snocList xs)
  equalSuffix [] ys | Empty = []
  equalSuffix (xs ++ [x]) ys | (Snoc xsrec) with (snocList ys)
    equalSuffix (xs ++ [x]) [] | (Snoc xsrec) | Empty = []
    equalSuffix (xs ++ [x]) (ys ++ [y]) | (Snoc xsRec) | (Snoc ysRec) =
      if x == y
        then equalSuffix xs ys | xsRec | ysRec ++ [x]
        else []

mergeSort : Ord a => Vect n a -> Vect n a
mergeSort xs with (splitRec xs)
  mergeSort [] | SplitRecNil = []
  mergeSort [x] | SplitRecOne = [x]
  mergeSort (xs ++ ys) | (SplitRecPair lrec rrec) =
    merge (mergeSort xs | lrec) (mergeSort ys | rrec)

toBinary : Nat -> String
toBinary k with (halfRec k)
  toBinary Z | HalfRecZ = ""
  toBinary (n + n) | (HalfRecEven rec) = toBinary n | rec ++ "0"
  toBinary (S (n + n)) | (HalfRecOdd rec) = toBinary n | rec ++ "1"

main : IO ()
main = do
  for ([0..10] ++ [42, 94]) $ \n =>
    printLn (n, toBinary n)
  pure ()

palindromeList : Eq a => List a -> Bool
palindromeList xs with (vList xs)
  palindromeList [] | VNil = True
  palindromeList [x] | VOne = True
  palindromeList (x :: (ys ++ [y])) | (VCons rec) =
    x == y && palindromeList ys | rec

palindrome : String -> Bool
palindrome = palindromeList . unpack
