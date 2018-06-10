|||
||| ### 15.2.3 Guaranteeing responses using a state machine and Inf
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

data ProcState = NoRequest | Sent | Complete

data Process :
  Type ->
  (inState : ProcState) ->
  (outState : ProcState) ->
  Type
where
  Action : (action : IO a) -> Process a state state
  Loop : Inf (Process a NoRequest Complete) -> Process a Sent Complete
  Spawn : Process () NoRequest Complete -> Process (Maybe MessagePID) state state
  Request : MessagePID -> Message -> Process Nat state state
  Respond :
    ((msg : Message) ->
    Process Nat NoRequest NoRequest) ->
    Process (Maybe Message) state Sent

  Pure : (val : a) -> Process a state state
  (>>=) :
    Process a state1 state2 ->
    (a -> Process b state2 state3) ->
    Process b state1 state3

%name Process process, process1, process2, process3

Service : Type -> Type
Service a = Process a NoRequest Complete

Client : Type -> Type
Client a = Process a NoRequest NoRequest

adder : Service ()
adder = do
  Action $ putStrLn "adder: Responding..."
  Respond $ \msg =>
    case msg of
      Add n m => do
        Action $ putStrLn $ "adder: Responding with " ++ show (n + m)
        Pure $ n + m
  Loop adder

-- Bad adders no longer compile.
{-
adderBad1 : Process () NoRequest Complete
adderBad1 = do
  Action (putStrLn "I'm out of the office today")
  Loop adderBad1

adderBad2 : Process () NoRequest Complete
adderBad2 = Loop adderBad1
-}

doMain : Client ()
doMain = do
  Action $ putStrLn "main: Spawning..."
  Just adderPid <- Spawn adder
    | Nothing => Action (putStrLn "main: Spawn failed")
  Action $ putStrLn "main: Requesting..."
  answer <- Request adderPid (Add 2 3)
  Action (putStrLn $ "Answer is " ++ show answer)

data Fuel = Dry | More (Lazy Fuel)

runWithFuel : Fuel -> Process t inState outState -> IO (Maybe t)
runWithFuel Dry process = do
  putStrLn "Out of fuel :("
  pure Nothing
runWithFuel (More fuel) process = run process
  where
    run : Process t inState outState -> IO (Maybe t)
    run (Action action) = pure Just <*> action
    run (Loop (Delay process)) = runWithFuel fuel process
    run (Spawn process) = do
      Just pid <- spawn (do result <- run process; pure ())
        | Nothing => pure Nothing
      pure $ pure (Just (MkMessage pid))
    run (Request (MkMessage pid) message) = do
      Just chan <- connect pid
        | Nothing => pure Nothing
      ok <- unsafeSend chan message
      if ok
      then do
        result <- unsafeRecv Nat chan
        pure result
      else pure Nothing
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

partial
infiniteFuel : Fuel
infiniteFuel = More infiniteFuel

partial
runProcess : Process () inState outState -> IO ()
runProcess process = do
  result <- runWithFuel infiniteFuel process
  putStrLn ("runProcess result: " ++ show result)
  pure ()

partial
main : IO ()
main = runProcess doMain
