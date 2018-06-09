|||
||| 15.1.2 The Channels library: primitive message passing
|||
module Main

import System.Concurrency.Channels

data Message = Add Nat Nat

adder : IO ()
adder = do
  Just senderChan <- listen 1
    | Nothing => adder
  Just msg <- unsafeRecv Message senderChan
    | Nothing => adder
  case msg of
    (Add x y) => do
      ok <- unsafeSend senderChan (x + y)
      printLn ("adder: unsafeSend => ", ok)
      adder

main : IO ()
main = do
  Just adderPid <- spawn adder
    | Nothing => putStrLn "Spawn failed"
  Just chan <- connect adderPid
    | Nothing => putStrLn "Connection failed"
  ok <- unsafeSend chan (Add 2 3)
  printLn ("main: unsafeSend => ", ok)
  Just answer <- unsafeRecv Nat chan
    | Nothing => putStrLn "unsafeRecv failed"
  printLn answer
