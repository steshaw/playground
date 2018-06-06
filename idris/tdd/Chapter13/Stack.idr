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

doAdd : StackCmd () (2 + height) (1 + height)
doAdd = do
  v1 <- Pop
  v2 <- Pop
  Push $ v1 + v2

data StackIO : Nat -> Type where
  Do :
    StackCmd a height1 height2 ->
    (a -> Inf (StackIO height2)) -> -- XXX: again `height2` seems ignored...
    StackIO height1

namespace StackDo
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
run (More fuel) stack (Do cmd cont) = do
  (res, newStack) <- runStack stack cmd
  run fuel newStack (cont res)

data Input
  = Number Integer
  | Add

strToInput : String -> Maybe Input
strToInput "" = Nothing
strToInput "add" = Just Add
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

partial
main : IO ()
main = run forever [] stackCalc
