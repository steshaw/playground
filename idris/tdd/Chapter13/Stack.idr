|||
||| ## 13.2 Dependent types in state: implementing a stack
|||
module Main

import Data.Vect

%default total

data StackCmd : Type -> Nat -> Nat -> Type where
  Push : Integer -> StackCmd () height (1 + height)
  Pop : StackCmd Integer (1 + height) height
  Top : StackCmd Integer (1 + height) (1 + height)

  GetStr : StackCmd String height height
  PutStr : String -> StackCmd () height height

  Pure : ty -> StackCmd ty height height
  (>>=) :
    StackCmd a height1 height2 ->
    (a -> StackCmd b height2 height3) ->
    StackCmd b height1 height3

%name StackCmd cmd

testAdd : StackCmd Integer 0 0
testAdd = do
  Push 10
  Push 20
  v1 <- Pop
  v2 <- Pop
  Pure (v1 + v2)

runStack :
  (stack : Vect inHeight Integer) ->
  StackCmd ty inHeight outHeight ->
  IO (ty, Vect outHeight Integer)
runStack stack (Push val) = pure ((), val :: stack)

runStack (val :: stack) Pop = pure (val, stack)
runStack stack@(val :: _) Top = pure (val, stack)

runStack stack GetStr = do
  line <- getLine
  pure (line, stack)
runStack stack (PutStr msg) = do
  putStr msg
  pure ((), stack)

runStack stack (Pure x) = pure (x, stack)
runStack stack (cmd >>= cont) = do
  (res, newStack) <- runStack stack cmd
  runStack newStack (cont res)

-- XXX: Argh: how to use this to reduce duplication with tryAdd/Mul/Sub.
BinOp : Nat -> Type
BinOp height = StackCmd () (2 + height) (1 + height)

doAdd : BinOp height
doAdd = do
  v1 <- Pop
  v2 <- Pop
  Push $ v1 + v2

doSub : BinOp height
doSub = do
  v1 <- Pop
  v2 <- Pop
  Push $ v2 - v1

doMul : BinOp height
doMul = do
  v1 <- Pop
  v2 <- Pop
  Push $ v2 * v1

doNeg : StackCmd () (1 + height) (1 + height)
doNeg = do
  v <- Pop
  Push $ negate v

doDiscard : StackCmd Integer (1 + height) height
doDiscard = do
  v <- Pop
  Pure v

doDuplicate : StackCmd Integer (1 + height) (2 + height)
doDuplicate = do
  v <- Top
  Push v
  Pure v

data StackIO : Nat -> Type where
  Quit : StackIO height
  Do :
    StackCmd a height1 height2 ->
    (a -> Inf (StackIO height2)) -> -- XXX: again `height2` seems ignored...
    StackIO height1

namespace StackDo
  pure : StackIO height
  pure = Quit

  (>>=) :
    StackCmd a height1 height2 ->
    (a -> Inf (StackIO height2)) ->
    StackIO height1
  (>>=) = Do

data Fuel = Dry | More (Lazy Fuel)

partial
forever : Fuel
forever = More forever

run : Fuel -> Vect height Integer -> StackIO height -> IO ()
run Dry _ _ = pure ()
run (More fuel) stack Quit =
  putStrLn $ "Quitting. Stack = " ++ show stack
run (More fuel) stack (Do cmd cont) = do
  (res, newStack) <- runStack stack cmd
  run fuel newStack (cont res)

data Input
  = Number Integer
  | Add
  | Sub
  | Mul
  | Neg
  | Discard
  | Duplicate
  | Empty
  | Exit

strToInput : String -> Maybe Input
strToInput "add" = Just Add
strToInput "sub" = Just Sub
strToInput "subtract" = Just Sub
strToInput "mul" = Just Mul
strToInput "multiply" = Just Mul
strToInput "neg" = Just Neg
strToInput "negate" = Just Neg
strToInput "discard" = Just Discard
strToInput "pop" = Just Discard
strToInput "duplicate" = Just Duplicate
strToInput "dup" = Just Duplicate
strToInput "" = Just Empty
strToInput "quit" = Just Exit
strToInput ":q" = Just Exit
strToInput "exit" = Just Exit
strToInput "stop" = Just Exit
strToInput str =
  if all isDigit (unpack str)
  then Just (Number (cast str))
  else Nothing

mutual
  tryAdd : StackIO height
  tryAdd {height = (S (S _))} = do
    doAdd
    result <- Top
    PutStr (show result ++ "\n")
    stackCalc
  tryAdd {height = _} = do
    PutStr "Fewer than two items on the stack\n"
    stackCalc

  trySub : StackIO height
  trySub {height = (S (S _))} = do
    doSub
    result <- Top
    PutStr (show result ++ "\n")
    stackCalc
  trySub {height = _} = do
    PutStr "Fewer than two items on the stack\n"
    stackCalc

  tryMul : StackIO height
  tryMul {height = (S (S _))} = do
    doMul
    result <- Top
    PutStr (show result ++ "\n")
    stackCalc
  tryMul {height = _} = do
    PutStr "Fewer than two items on the stack\n"
    stackCalc

  tryNeg : StackIO height
  tryNeg {height = (S _)} = do
    doNeg
    result <- Top
    PutStr (show result ++ "\n")
    stackCalc
  tryNeg {height = _} = do
    PutStr "Needs at least one item on the stack\n"
    stackCalc

  tryDiscard : StackIO height
  tryDiscard {height = (S _)} = do
    v <- doDiscard
    PutStr ("Discarded " ++ show v ++ "\n")
    stackCalc
  tryDiscard {height = _} = do
    PutStr "Needs at least one item on the stack\n"
    stackCalc

  tryDuplicate : StackIO height
  tryDuplicate {height = (S _)} = do
    v <- doDuplicate
    PutStr ("Duplicated " ++ show v ++ "\n")
    stackCalc
  tryDuplicate {height = _} = do
    PutStr "Needs at least one item on the stack\n"
    stackCalc

  stackCalc : StackIO height
  stackCalc = do
    PutStr "> "
    str <- GetStr
    case strToInput str of
      Nothing => do
        PutStr "Invalid input\n"
        stackCalc
      (Just (Number x)) => do
        Push x
        stackCalc
      (Just Add) => tryAdd
      (Just Sub) => trySub
      (Just Mul) => tryMul
      (Just Neg) => tryNeg
      (Just Discard) => tryDiscard
      (Just Duplicate) => tryDuplicate
      (Just Empty) => stackCalc
      (Just Exit) => do
        PutStr "bye!\n"
        Quit

partial
main : IO ()
main = run forever [] stackCalc
