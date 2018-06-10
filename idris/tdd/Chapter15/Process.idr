|||
||| ## 15.2 Defining a type for safe message passing
|||
module Main

import System.Concurrency.Channels

%default total

data MessagePID = MkMessage PID

%name MessagePID pid

data Message = Add Nat Nat

Show Message where
  show (Add k j) = "Add " ++ show k ++ " " ++ show j

%name Message message

data Process : Type -> Type where
  Action : (action : IO a) -> Process a
  Spawn : Process () -> Process (Maybe MessagePID)
  Request : MessagePID -> Message -> Process (Maybe Nat)
  Respond : ((msg : Message) -> Process Nat) -> Process (Maybe Message)

  Pure : (val : a) -> Process a
  (>>=) : Process a -> (a -> Process b) -> Process b

%name Process process, process1, process2, process3

run : Process t -> IO t
run (Action action) = action
run (Spawn process) = do
  Just pid <- spawn (run process)
    | Nothing => pure Nothing
  pure (Just (MkMessage pid))
run (Request (MkMessage pid) message) = do
  Just chan <- connect pid
    | Nothing => pure Nothing
  ok <- unsafeSend chan message
  if ok
  then do
    Just n <- unsafeRecv Nat chan
      | Nothing => pure Nothing
    pure (Just n)
  else pure Nothing
run (Respond f) = do
  putStrLn "Listen"
  Just senderChannel <- listen 1
    | Nothing => pure Nothing
  putStrLn "Got sender channel"
  putStrLn "Doing unsafeRecv"
  Just message <- unsafeRecv Message senderChannel
    | Nothing => pure Nothing
  putStrLn $ "Received " ++ show message
  result <- run (f message)
  unsafeSend senderChannel result
  pure (Just message)
run (Pure val) = pure val
run (process >>= cont) = do
  result <- run process
  run (cont result)

partial
adder : Process ()
adder = do
  Action $ putStrLn "adder: Responding..."
  Respond $ \msg =>
    case msg of
      Add n m => do
        Action $ putStrLn $ "adder: Responding with " ++ show (n + m)
        Pure $ n + m
  adder

partial
doMain : Process ()
doMain = do
  Action $ putStrLn "main: Spawning..."
  Just adderPid <- Spawn adder
    | Nothing => Action (putStrLn "main: Spawn failed")
  Action $ putStrLn "main: Requesting..."
  Just answer <- Request adderPid (Add 2 3)
    | Nothing => Action (putStrLn "main: Request failed")
  Action (printLn answer)

partial
main : IO ()
main = run doMain
