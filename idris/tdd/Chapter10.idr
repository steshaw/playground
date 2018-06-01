|||
||| # 10: Views: extending pattern matching
|||
module Chapter10

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
