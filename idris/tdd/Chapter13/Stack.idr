|||
||| ## 13.2 Dependent types in state: implementing a stack
|||
module Stack

import Data.Vect

%default total

data StackCmd : Type -> Nat -> Nat -> Type where
  Push : Integer -> StackCmd () height (1 + height)
  Pop : StackCmd Integer (1 + height) height
  Top : StackCmd Integer (1 + height) (1 + height)

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
  (ty, Vect outHeight Integer)
runStack stack (Push val) = ((), val :: stack)
runStack (val :: stack) Pop = (val, stack)
runStack stack@(val :: _) Top = (val, stack)

runStack stack (Pure x) = (x, stack)
runStack stack (cmd >>= cont) =
  let (res, newStack) = runStack stack cmd
  in runStack newStack (cont res)

doAdd : StackCmd () (2 + height) (1 + height)
doAdd = do
  v1 <- Pop
  v2 <- Pop
  Push $ v1 + v2
