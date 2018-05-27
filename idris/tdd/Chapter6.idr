module Chapter6

import Data.Vect

%default total

StringOrInt : Bool -> Type
StringOrInt False = String
StringOrInt True = Int

getStringOrInt : (isInt : Bool) -> StringOrInt isInt
getStringOrInt False = "Fourty two"
getStringOrInt True = 42

valToString : (isInt : Bool) -> StringOrInt isInt -> String
valToString False s = trim s
valToString True i = cast i

eg1 : valToString True 42 = "42"
eg1 = Refl

eg2 : valToString False "  Fourty two  " = "Fourty two"
eg2 = Refl

valToString2 :
  (isInt : Bool) ->
  (case isInt of
    False => String
    True => Int) ->
  String
valToString2 False s = trim s
valToString2 True i = cast i

eg3 : valToString2 True 42 = "42"
eg3 = Refl

eg4 : valToString2 False "  Fourty two  " = "Fourty two"
eg4 = Refl

AdderType : (numArgs : Nat) -> Type
AdderType Z = Int
AdderType (S k) = Int -> AdderType k

eg5 : AdderType 0 = Int
eg5 = Refl

eg6 : AdderType 1 = (Int -> Int)
eg6 = Refl

eg7 : AdderType 2 = (Int -> Int -> Int)
eg7 = Refl

adder : (numargs : Nat) -> (acc : Int) -> AdderType numargs
adder Z acc = acc
adder (S k) acc = \i => adder k (acc + i)

--
-- Type-safe printf
--

data Format
  = Number Format
  | Str Format
  | FChar Format
  | FDouble Format
  | Lit String Format
  | End

%name Format format, format1, format2, format3

PrintfType : Format -> Type
PrintfType (Number format) = (i : Int) -> PrintfType format
PrintfType (Str format) = (s : String) -> PrintfType format
PrintfType (FChar format) = (c : Char) -> PrintfType format
PrintfType (FDouble format) = (c : Double) -> PrintfType format
PrintfType (Lit s format) = PrintfType format
PrintfType End = String

printfFmt : (fmt : Format) -> (acc : String) -> PrintfType fmt
printfFmt (Number format) acc = \i => printfFmt format (acc ++ show i)
printfFmt (Str format) acc = \s => printfFmt format (acc ++ s)
printfFmt (FChar format) acc = \c => printfFmt format (acc ++ singleton c)
printfFmt (FDouble format) acc = \d => printfFmt format (acc ++ show d)
printfFmt (Lit lit format) acc = printfFmt format (acc ++ lit)
printfFmt End acc = acc

toFormat : (cs : List Char) -> Format
toFormat [] = End
toFormat ('%' :: 'd' :: cs) = Number (toFormat cs)
toFormat ('%' :: 's' :: cs) = Str (toFormat cs)
toFormat ('%' :: 'c' :: cs) = FChar (toFormat cs)
toFormat ('%' :: 'f' :: cs) = FDouble (toFormat cs)
toFormat ('%' :: cs) = Lit "%" (toFormat cs)
toFormat (c :: cs) =
  case toFormat cs of
    (Lit lit format) => Lit (strCons c lit) format
    format => Lit (singleton c) format

printf : (fmt : String) -> PrintfType (toFormat (unpack fmt))
printf fmt = printfFmt _ ""

-- Exercises

Matrix : Nat -> Nat -> Type
Matrix n m = Vect n (Vect m Double)

zeroMatrix : Matrix 2 3
zeroMatrix = [[0, 0, 0], [0, 0, 0]]

{-
TupleVect 0 ty = ()
TupleVect 1 ty = (ty, ())
TupleVect 2 ty = (ty, (ty, ()))
-}

TupleVect : (n : Nat) -> (ty : Type) -> Type
TupleVect Z ty = ()
TupleVect (S k) ty = (ty, TupleVect k ty)

tupleVectEg1 : TupleVect 4 Nat
tupleVectEg1 = (1, 2, 3, 4, ())

tupleVectEg2 : TupleVect 0 Nat
tupleVectEg2 = ()

tupleVectEg3 : TupleVect 1 Nat
tupleVectEg3 = (1, ())

tupleVectEg4 : TupleVect 2 Nat
tupleVectEg4 = (2, (1, ()))
