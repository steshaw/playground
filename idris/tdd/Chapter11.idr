|||
||| # 11 Streams and processes: working with infinite data
|||
module Main

import Data.Primitives.Views
import System

%default total

--
-- ## 11.1 Streams: generating and processing infinite lists
--

labelFrom  : Integer -> List a -> List (Integer, a)
labelFrom label [] = []
labelFrom label (x :: xs) = (label, x) :: labelFrom (label + 1) xs

label1 : List a -> List (Integer, a)
label1 = labelFrom 0

-- Never terminates.
partial
countFrom1 : Integer -> List Integer
countFrom1 n = n :: countFrom1 (n + 1)

data InfList : Type -> Type where
  (::) : (value : elem) -> Inf (InfList elem) -> InfList elem

%name InfList xs, ys, zs

countFrom : Integer -> InfList Integer
countFrom n = n :: Delay (countFrom (n + 1))

getPrefix : (count : Nat) -> InfList ty -> List ty
getPrefix Z xs = []
getPrefix (S k) (value :: xs) = value :: getPrefix k xs

labelWith : Stream labelType -> List a -> List (labelType, a)
labelWith xs [] = []
labelWith (label :: labels) (x :: xs) = (label, x) :: labelWith labels xs

label : List a -> List (Integer, a)
label = labelWith [0..]

partial
quiz1 : Stream Int -> (score : Nat) -> IO ()
quiz1 (num1 :: num2 :: nums) score = do
  putStrLn $ "Score so far: " ++ show score
  putStr $ show num1 ++ " * " ++ show num2 ++ "? "
  answer <- getLine
  if cast answer == num1 * num2
    then do
      putStrLn "Correct!"
      quiz1 nums (score + 1)
    else do
      putStrLn $ "Wrong, the answer is " ++ show (num1 * num2)
      quiz1 nums score

randoms : Int -> Stream Int
randoms seed =
  let seed' = 1664525 * seed + 1013904223
  in (seed' `shiftR` 2) :: randoms seed'

arithInputs : Int -> Stream Int
arithInputs seed = map bound (randoms seed)
  where
  bound : Int -> Int
  bound num with (divides num 12)
    bound ((12 * div) + rem) | (DivBy prf) = rem + 1

--
-- Exercises
--

everyOther : Stream a -> Stream a
everyOther (value :: (x :: xs)) = x :: everyOther xs

implementation Functor InfList where
  map f (value :: xs) = (f value) :: map f xs

data Face = Heads | Tails

coinFlips : (count : Nat) -> Stream Int -> List Face
coinFlips count randomness = take count $ map toFace randomness
  where
    toFace i = if i < 0 then Heads else Tails

squareRootApprox : (number : Double) -> (approx : Double) -> Stream Double
squareRootApprox number approx =
  let nextApprox = (approx + (number / approx)) / 2
  in approx :: squareRootApprox number nextApprox

squareRootBound :
  (max : Nat) ->
  (number : Double) ->
  (bound : Double) ->
  (approxs : Stream Double) ->
  Double
squareRootBound Z number bound (approx :: approxs) = approx
squareRootBound (S k) number bound (approx :: approxs) =
  if abs (number - approx) < bound
    then approx
    else squareRootBound k number bound approxs

squareRoot : (number : Double) -> Double
squareRoot number =
  squareRootBound 100 number 0.00000000001
    (squareRootApprox number number)

--
-- ## 11.2 Infinite processes: writing interactive total programs
--

data InfIO : Type where
  Do : IO a -> (a -> Inf InfIO) -> InfIO

loopPrint1 : String -> InfIO
loopPrint1 msg =
  Do (putStrLn msg) (\_ => loopPrint1 msg)

partial
run1 : InfIO -> IO ()
run1 (Do action cont) = do
  result <- action
  run1 (cont result)

data Fuel = Dry | More (Lazy Fuel)

tank : Nat -> Fuel
tank Z = Dry
tank (S k) = More (tank k)

run : Fuel -> InfIO -> IO ()
run Dry y = putStrLn "Out of fuel"
run (More fuel) (Do action cont) = do
  result <- action
  run fuel (cont result)

partial
forever : Fuel
forever = More forever

(>>=) : IO a -> (a -> Inf InfIO) -> InfIO
(>>=) = Do

loopPrint : String -> InfIO
loopPrint msg = do
  putStrLn msg
  loopPrint msg

quiz : Stream Int -> (score : Nat) -> InfIO
quiz (num1 :: num2 :: nums) score = do
  putStrLn $ "Score so far: " ++ show score
  putStr $ show num1 ++ " * " ++ show num2 ++ "? "
  answer <- getLine
  if cast answer == num1 * num2
    then do
      putStrLn "Correct!"
      quiz nums (score + 1)
    else do
      putStrLn $ "Wrong, the answer is " ++ show (num1 * num2)
      quiz nums score

doQuiz : InfIO
doQuiz = do
  seed <- time
  quiz (arithInputs (fromInteger seed)) 0

partial
main : IO ()
main = run forever doQuiz

--
-- Exercises
--

totalREPL : (prompt : String) -> (action : String -> String) -> InfIO
totalREPL prompt action = do
  putStr prompt
  line <- getLine
  putStrLn $ action line
  totalREPL prompt action
