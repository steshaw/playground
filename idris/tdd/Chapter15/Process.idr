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
  Loop : Inf (Process a) -> Process a
  Spawn : Process () -> Process (Maybe MessagePID)
  Request : MessagePID -> Message -> Process (Maybe Nat)
  Respond : ((msg : Message) -> Process Nat) -> Process (Maybe Message)

  Pure : (val : a) -> Process a
  (>>=) : Process a -> (a -> Process b) -> Process b

%name Process process, process1, process2, process3

data Fuel = Dry | More (Lazy Fuel)

runWithFuel : Fuel -> Process t -> IO (Maybe t)
runWithFuel Dry process = do
  putStrLn "Out of fuel :("
  pure Nothing
runWithFuel (More fuel) process = run process
  where
    run : Process t -> IO (Maybe t)
    run (Action action) = pure Just <*> action
    run (Loop (Delay process)) = runWithFuel fuel process
    run (Spawn process) = do
      Just pid <- spawn (do result <- run process; pure ())
        | Nothing => pure Nothing
      pure $ pure (Just (MkMessage pid))
    run (Request (MkMessage pid) message) = do
      Just chan <- connect pid
        | Nothing => pure (pure Nothing)
      ok <- unsafeSend chan message
      if ok
      then do
        Just n <- unsafeRecv Nat chan
          | Nothing => pure (pure Nothing)
        pure $ pure $ pure n
      else pure $ pure Nothing
    run (Respond f) = do
      putStrLn "Listen"
      Just senderChannel <- listen 1
        | Nothing => pure (pure Nothing)
      putStrLn "Got sender channel"
      putStrLn "Doing unsafeRecv"
      Just message <- unsafeRecv Message senderChannel
        | Nothing => pure (pure Nothing)
      putStrLn $ "Received " ++ show message
      Just result <- run (f message)
        | Nothing => pure Nothing
      unsafeSend senderChannel result
      pure $ pure (Just message)
    run (Pure val) = pure $ pure val
    run (process >>= cont) = do
      Just result <- run process
        | Nothing => pure Nothing
      run (cont result)

adder : Process ()
adder = do
  Action $ putStrLn "adder: Responding..."
  Respond $ \msg =>
    case msg of
      Add n m => do
        Action $ putStrLn $ "adder: Responding with " ++ show (n + m)
        Pure $ n + m
  Loop adder

doMain : Process ()
doMain = do
  Action $ putStrLn "main: Spawning..."
  Just adderPid <- Spawn adder
    | Nothing => Action (putStrLn "main: Spawn failed")
  Action $ putStrLn "main: Requesting..."
  Just answer <- Request adderPid (Add 2 3)
    | Nothing => Action (putStrLn "main: Request failed")
  Action (putStrLn $ "Answer is " ++ show answer)

partial
infiniteFuel : Fuel
infiniteFuel = More infiniteFuel

partial
runProcess : Process () -> IO ()
runProcess process = do
  result <- runWithFuel infiniteFuel process
  putStrLn ("runProcess result: " ++ show result)
  pure ()

partial
main : IO ()
main = runProcess doMain

adderBad1 : Process ()
adderBad1 = do
  Action (putStrLn "I'm out of the office today")
  Loop adderBad1

adderBad2 : Process ()
adderBad2 = Loop adderBad1
