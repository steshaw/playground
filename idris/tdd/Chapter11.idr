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

--
-- ## 11.3 Interactive programs with termination
--

namespace InteractiveProgramsWithTermination

  greet1 : InfIO
  greet1 = do
    putStr "Enter your name: "
    name <- getLine
    putStrLn ("Hello " ++ name)
    greet1

  data RunIO : Type -> Type where
    Quit : a -> RunIO a
    Do : IO a -> (a -> Inf (RunIO b)) -> RunIO b

  (>>=) : IO a -> (a -> Inf (RunIO b)) -> RunIO b
  (>>=) = Do

  greet : RunIO ()
  greet = do
    putStr "Enter your name: "
    name <- getLine
    if name == ""
      then do
        putStrLn "Bye bye!"
        Quit ()
      else do
        putStrLn ("Hello " ++ name)
        greet

  run : Fuel -> RunIO a -> IO (Maybe a)
  run _ (Quit value) = pure (Just value)
  run (More fuel) (Do action cont) = do
    result <- action
    run fuel (cont result)
  run Dry _ = pure Nothing

  partial
  main1 : IO ()
  main1 = do
    r <- run forever greet
    printLn r

namespace DomainSpecificCommands

  data Command : Type -> Type where
    PutStr : String -> Command ()
    GetLine : Command String

  data ConsoleIO : Type -> Type where
    Quit : a -> ConsoleIO a
    Do : Command a -> (a -> Inf (ConsoleIO b)) -> ConsoleIO b

  (>>=) : Command a -> (a -> Inf (ConsoleIO b)) -> ConsoleIO b
  (>>=) = Do

  runCommand : Command a -> IO a
  runCommand (PutStr x) = putStr x
  runCommand GetLine = getLine

  run : Fuel -> ConsoleIO a -> IO (Maybe a)
  run fuel (Quit val) = pure (Just val)
  run Dry (Do y f) = pure Nothing
  run (More fuel) (Do command cont) = do
    result <- runCommand command
    run fuel (cont result)

  quiz : Stream Int -> (score : Nat) -> ConsoleIO Nat
  quiz (num1 :: num2 :: nums) score = do
    PutStr $ "Score so far: " ++ show score
    PutStr "\n"
    PutStr $ show num1 ++ " * " ++ show num2 ++ "? "
    answer <- GetLine
    if toLower answer == "quit"
      then Quit score
      else
        if cast answer == num1 * num2
          then correct
          else wrong
  where
    correct = do
      PutStr "Correct!\n"
      quiz nums (score + 1)
    wrong = do
      PutStr $ "Wrong, the answer is " ++ show (num1 * num2)
      PutStr "\n"
      quiz nums score

  doQuiz : Integer -> ConsoleIO Nat
  doQuiz seed =
    quiz (arithInputs (fromInteger seed)) 0

  doMain : Fuel -> IO ()
  doMain fuel = do
    seed <- time
    Just score <- DomainSpecificCommands.run fuel $ doQuiz seed
      | Nothing => putStrLn "Ran out of fuel :("
    putStrLn $ "Final score: " ++ show score

  partial
  main : IO ()
  main = doMain forever

namespace ArithCmdDo

  data Input
    = Answer Int
    | QuitCmd

  data Command2 : Type -> Type where
    PutStr2 : String -> Command2 ()
    GetLine2 : Command2 String

    ReadFile : (filepath : String) -> Command2 (Either FileError String)
    WriteFile :
      (filepath : String) ->
      (contents : String) ->
      Command2 (Either FileError ())

    Pure : ty -> Command2 ty
    Bind : Command2 a -> (a -> Command2 b) -> Command2 b

  data ConsoleIO2 : Type -> Type where
    Quit : a -> ConsoleIO2 a
    Do : Command2 a -> (a -> Inf (ConsoleIO2 b)) -> ConsoleIO2 b

  runCommand : Command2 a -> IO a
  runCommand (PutStr2 x) = putStr x
  runCommand GetLine2 = getLine
  runCommand (ReadFile filePath) = readFile filePath
  runCommand (WriteFile filePath contents) = writeFile filePath contents
  runCommand (Pure val) = pure val
  runCommand (Bind action cont) = do
    result <- runCommand action
    runCommand (cont result)

  namespace Command2Do
    (>>=) : Command2 a -> (a -> Command2 b) -> Command2 b
    (>>=) = Bind

  namespace ConsoleIO2Do
    (>>=) : Command2 a -> (a -> Inf (ConsoleIO2 b)) -> ConsoleIO2 b
    (>>=) = Do

  readInput : (prompt : String) -> Command2 Input
  readInput prompt = do
    PutStr2 prompt
    answer <- GetLine2
    if toLower answer == "quit"
      then Pure QuitCmd
      else Pure (Answer (cast answer))

  quiz2 : Stream Int -> (score : Nat) -> (total_ : Nat) -> ConsoleIO2 (Nat, Nat)
  quiz2 (num1 :: num2 :: nums) score total_ = do
    PutStr2 $ "Score so far: " ++ show score ++ "/" ++ show total_
    PutStr2 "\n"
    input <- readInput $ show num1 ++ " * " ++ show num2 ++ "? "
    case input of
      Answer answer => if answer == num1 * num2
        then correct
        else wrong
      QuitCmd => Quit (score, total_)
  where
    correct : ConsoleIO2 (Nat, Nat)
    correct = do
      PutStr2 "Correct!\n"
      quiz2 nums (score + 1) (total_ + 1)
    wrong : ConsoleIO2 (Nat, Nat)
    wrong = do
      PutStr2 $ "Wrong, the answer is " ++ show (num1 * num2)
      PutStr2 "\n"
      quiz2 nums score (total_ + 1)

  run : Fuel -> ConsoleIO2 a -> IO (Maybe a)
  run fuel (Quit val) = pure (Just val)
  run Dry (Do y f) = pure Nothing
  run (More fuel) (Do command cont) = do
    result <- runCommand command
    run fuel (cont result)

  doQuiz : Integer -> ConsoleIO2 (Nat, Nat)
  doQuiz seed =
    quiz2 (arithInputs (fromInteger seed)) 0 0

  doMain : Fuel -> IO ()
  doMain fuel = do
    seed <- time
    Just (score, total_) <- ArithCmdDo.run fuel $ doQuiz seed
      | Nothing => putStrLn "Ran out of fuel :("
    putStrLn $ "Final score: " ++ show score ++ "/" ++ show total_

  partial
  main : IO ()
  main = ArithCmdDo.doMain forever

  data Cmd : Type where
    Cat : (filePath : String) -> Cmd
    Copy : (sourcePath : String) -> (destinationPath : String) -> Cmd
    Exit : Cmd
    Empty : Cmd

  parseCmd : String -> Either String Cmd
  parseCmd input = case split (== ' ') input of
    ["cat", filePath] => Right (Cat filePath)
    ["cp", src, dst] => Right (Copy src dst)
    ["copy", src, dst] => Right (Copy src dst)
    ["exit"] => Right Exit
    [""] => Right Empty
    [] => Right Empty
    _ => Left "invalid command"

  doCat : (filePath : String) -> Command2 ()
  doCat filePath = do
    Right contents <- ReadFile filePath
      | Left fileError => do
          PutStr2 ("Error: " ++ show fileError ++ "\n")
    PutStr2 contents

  doCopy : (src : String) -> (dst : String) -> Command2 ()
  doCopy src dst = do
    PutStr2 $ "Copying " ++ src ++ " to " ++ dst ++ "\n"
    Right contents <- ReadFile src
      | Left fileError => do
          PutStr2 ("Error: " ++ show fileError ++ "\n")
    Right () <- WriteFile dst contents
      | Left fileError => do
          PutStr2 ("Error: " ++ show fileError ++ "\n")
    Pure ()

  evalCmd : Cmd -> Command2 Bool
  evalCmd (Cat filePath) = do
    doCat filePath
    Pure False
  evalCmd (Copy src dst) = do
    doCopy src dst
    Pure False
  evalCmd Exit = do
    PutStr2 "Exiting..."
    Pure True
  evalCmd Empty = Pure False

  shell : String -> ConsoleIO2 ()
  shell prompt = do
    PutStr2 prompt
    input <- GetLine2
    case parseCmd input of
      Left error => do
        PutStr2 $ "Error: " ++ error ++ "\n"
        shell prompt
      Right cmd => do
        shouldExit <- evalCmd cmd
        if shouldExit then
          Quit ()
        else shell prompt

  partial
  shellMain : IO ()
  shellMain = do
    result <- run forever (shell "$ ")
    printLn result
