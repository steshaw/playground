|||
||| 9: Predicates: expressing assumptions and contracts in types
|||
module Chapter9

%default total

data Vect : Nat -> Type -> Type where
  Nil :Vect Z a
  (::) : a -> Vect k a -> Vect (S k) a

%name Vect xs, ys, zs

--
-- ## 9.1 Membership tests: the Elem predicate
--

-- This formulation does not work!
{-
removeElem : DecEq a => (value : a) -> (xs : Vect (S n) a) -> Vect n a
removeElem value (x :: xs) =
  case decEq value x of
    Yes prf => xs
    No contra => x :: removeElem x xs -- <-- type error here.
-}

data Elem : a -> Vect k a -> Type where
  Here : Elem x (x :: xs)
  There : (later : Elem x xs) -> Elem x (_ :: xs)

implementation Uninhabited (Elem a []) where
  uninhabited Here impossible
  uninhabited (There _) impossible

oneInVector : Elem 1 [1, 2, 3]
oneInVector = Here

maryInVector : Elem "Mary" ["Peter", "Paul", "Mary"]
maryInVector = There (There Here)

removeElem1 :
  (x : a) ->
  (xs : Vect (S n) a) ->
  (prf : Elem value xs) ->
  Vect n a
removeElem1 x (x :: xs) Here = xs
removeElem1 value (x :: []) (There later) {n = Z} =
  absurd later -- <-- sorta/kinda similar to `impossible`
  -- Note that this also worked when defined was `xs`, as we were
  -- needing a `Vect 0 a`. However, the clause never gets selected
  -- because it cannot happen due to the `later` being absurd/impossible.
removeElem1 value (x :: xs) (There later) {n = (S k)} = x :: removeElem1 value xs later

removeElem2 :
  (x : a) ->
  (xs : Vect (S n) a) ->
  {auto prf : Elem x xs} ->
  Vect n a
removeElem2 x xs {prf} = removeElem1 x xs prf

removeElem3 :
  (x : a) ->
  (xs : Vect (S n) a) ->
  {auto prf : Elem x xs} ->
  Vect n a
removeElem3 x (x :: ys) {prf = Here} = ys
removeElem3 x (y :: []) {prf = There later} {n = Z} = absurd later
removeElem3 x (y :: ys) {prf = There later} {n = (S k)} = y :: removeElem3 x ys

notInNil : Elem value [] -> Void
notInNil Here impossible
notInNil (There _) impossible

notInTail :
  (notHere : (x = y) -> Void) ->
  (notThere : Elem x xs -> Void) ->
  Elem x (y :: xs) -> Void
notInTail notHere notThere Here = notHere Refl
notInTail notHere notThere (There later) = notThere later

isElem : DecEq a => (x : a) -> (xs : Vect n a) -> Dec (Elem x xs)
isElem x [] = No notInNil
isElem x (y :: xs) =
  case decEq x y of
    Yes Refl => Yes Here
    No notHere =>
      case isElem x xs of
        Yes prf => Yes (There prf)
        No notThere => No (notInTail notHere notThere)

--
-- Exercises
--

data LElem : a -> List a -> Type where
  LHere : LElem x (x :: _)
  LThere : (later : LElem x xs) -> LElem x (_ :: xs)

eg1 : LElem 1 [1, 2, 3]
eg1 = LHere

eg2 : LElem 2 [1, 2, 3]
eg2 = LThere LHere

eg3 : LElem 2 [1, 2, 3]
eg3 = LThere LHere

data Last : List a -> a -> Type where
  LastOne : Last [value] value
  LastCons : (prf : Last xs value) -> Last (x :: xs) value

last123 : Last [1,2,3] 3
last123 = LastCons (LastCons LastOne)

noNil : Last [] value -> Void
noNil LastOne impossible
noNil (LastCons _) impossible

notLast : (contra : (x = value) -> Void) -> Last [x] value -> Void
notLast contra LastOne = contra Refl
notLast _ (LastCons LastOne) impossible
notLast _ (LastCons (LastCons _)) impossible

notCons : (contra : Last (y :: xs) value -> Void) -> Last (x :: (y :: xs)) value -> Void
notCons contra (LastCons prf) = contra prf

isLast : DecEq a => (xs : List a) -> (value : a) -> Dec (Last xs value)
isLast [] value = No noNil
isLast (x :: []) value = case decEq x value of
                            Yes Refl => Yes LastOne
                            No contra => No (notLast contra)
isLast (x :: (y :: xs)) value = case isLast (y :: xs) value of
                                     Yes prf => Yes (LastCons prf)
                                     No contra => No (notCons contra)
