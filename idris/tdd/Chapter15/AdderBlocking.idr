|||
||| 15.1.3 Problems with channels: blocking
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

add : Channel -> IO ()
add chan = do
  ok <- unsafeSend chan (Add 2 3)
  printLn ("main: unsafeSend => ", ok)
  Just answer <- unsafeRecv Nat chan
    | Nothing => putStrLn "unsafeRecv failed"
  printLn answer

main : IO ()
main = do
  Just adderPid <- spawn adder
    | Nothing => putStrLn "Spawn failed"
  Just chan <- connect adderPid
    | Nothing => putStrLn "Connection failed"

  add chan
  add chan -- <<- This will block the program since adder only responds to the first message
