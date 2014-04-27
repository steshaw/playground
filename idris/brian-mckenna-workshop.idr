--
-- See http://brianmckenna.org/files/presentations/idris-workshop-slides.pdf
--

%default total

isIdris : Bool
isIdris = True

one : Nat
one = if isIdris then S Z else Z

StringList : Type
StringList = if isIdris then List Char else Int

the : (t : Type) -> (x : t) -> t
the _ a = a

one' : Nat
one' = Main.the Nat Z

id1 : {t : Type} -> (x : t) -> t
id1 {t} a = a

id2 : (x : t) -> t
id2 a = a

id3 : t -> t
id3 a = a

Option : Type -> Type
Option = Maybe

Some : a -> Option a
Some = Just

None : Option a
None = Nothing

total plusOne : Nat -> Nat
plusOne Z = S Z
plusOne (S n) = S (S n)

{-
 -- FIX
data (=) : a -> b -> Type where
  refl : x = x
-}

x : 1 = 1
x = refl

y : 1 + 1 = 2
y = refl

x' : {a : Nat} -> a - a = Z
x' {a=Z} = refl
x' {a=S k} = x' {a=k}

y' : {a : Nat} -> a - a = Z
y' {a} = replace {P = \x => (a - x = Z)}
          (plusZeroRightNeutral a)
          (minusPlusZero a Z)

xx : {a : Nat} -> a - a = Z
xx = ?xxproof

xxproof = proof
  intros
  rewrite (minusPlusZero a Z)
  rewrite (plusZeroRightNeutral a)
  trivial
