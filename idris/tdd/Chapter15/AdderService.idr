|||
||| 15.1.3 Problems with channels: blocking
|||
||| Here, the blocking example has been fixed. It's now a "service" which
||| does not block the whole program (it continues to listen on it's channel).
|||
module Main

import System.Concurrency.Channels

data Message = Add Nat Nat

adderService : Channel -> IO ()
adderService senderChan = service
  where
    service = do
      Just msg <- unsafeRecv Message senderChan
        | Nothing => do
          putStrLn "adder: unsafeRecv returned Nothing"
          service
      case msg of
        (Add x y) => do
          ok <- unsafeSend senderChan (x + y)
          printLn ("adder: unsafeSend => ", ok)
          service

adder : IO ()
adder = do
  Just senderChan <- listen 1
    | Nothing => adder
  adderService senderChan

add : Channel -> Nat -> Nat -> IO ()
add chan a b = do
  ok <- unsafeSend chan (Add a b)
  printLn ("main: unsafeSend => ", ok)
  Just answer <- unsafeRecv Nat chan
    | Nothing => putStrLn "unsafeRecv failed"
  putStrLn (show a ++ " + " ++ show b ++ " => " ++ show answer)

main : IO ()
main = do
  Just adderPid <- spawn adder
    | Nothing => putStrLn "Spawn failed"
  Just chan <- connect adderPid
    | Nothing => putStrLn "Connection failed"

  for [1..3] $ \a =>
    for [2..4] $ \b =>
      add chan a b
  pure ()
