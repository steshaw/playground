|||
||| ### 15.2.4 Generic message-passing processes
|||
||| Known as ProcessIFace.idr in the book.
|||
module Main

import System.Concurrency.Channels

%default total

-- TODO: Define alias for (reqType -> Type)
{-
IFace : Type
IFace = (reqType -> Type)
-}

data MessagePID : (iface : reqType -> Type) -> Type where
  MkMessage : PID -> MessagePID iface

%name MessagePID pid

data Message = Add Nat Nat

Show Message where
  show (Add k j) = "Add " ++ show k ++ " " ++ show j

%name Message message

data ProcState = NoRequest | Sent | Complete

data Process :
  (iface : reqType -> Type) ->
  Type ->
  (inState : ProcState) ->
  (outState : ProcState) ->
  Type
where
  Action :
    (action : IO a) ->
    Process iface a state state
  Loop :
    Inf (Process iface a NoRequest Complete) ->
    Process iface a Sent Complete
  Spawn :
    Process serviceIFace () NoRequest Complete ->
    Process iface (Maybe (MessagePID serviceIFace)) state state
  Request :
    MessagePID serviceIFace ->
    (msg : serviceReqType) ->
    Process iface (serviceIFace msg) state state
  Respond :
    ((msg : reqType) ->
    Process iface (iface msg) NoRequest NoRequest) ->
    Process iface (Maybe reqType) state Sent

  Pure :
    (val : a) ->
    Process iface a state state
  (>>=) :
    Process iface a state1 state2 ->
    (a -> Process iface b state2 state3) ->
    Process iface b state1 state3

%name Process process, process1, process2, process3

Service : (reqType -> Type) -> Type -> Type
Service iface a = Process iface a NoRequest Complete

NoRecv : Void -> Type
NoRecv = const Void

Client : Type -> Type
Client a = Process NoRecv a NoRequest NoRequest

AdderType : Message -> Type
AdderType (Add x y) = Nat

adder : Service AdderType ()
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

runWithFuel : Fuel -> Process iface t inState outState -> IO (Maybe t)
runWithFuel Dry process = do
  putStrLn "Out of fuel :("
  pure Nothing
runWithFuel (More fuel) process = run process
  where
    run : Process iface t inState outState -> IO (Maybe t)
    run (Action action) = pure Just <*> action
    run (Loop (Delay process)) = runWithFuel fuel process
    run (Spawn process) = do
      Just pid <- spawn (do result <- run process; pure ())
        | Nothing => pure Nothing
      pure $ pure (Just (MkMessage pid))
    run (Request {serviceIFace} (MkMessage pid) message) = do
      Just chan <- connect pid
        | Nothing => pure Nothing
      ok <- unsafeSend chan message
      if ok
      then do
        result <- unsafeRecv (serviceIFace message) chan
        pure result
      else pure Nothing
    run (Respond {reqType} f) = do
      putStrLn "Listen"
      Just senderChannel <- listen 1
        | Nothing => pure (pure Nothing)
      putStrLn "Got sender channel"
      putStrLn "Doing unsafeRecv"
      Just message <- unsafeRecv reqType senderChannel
        | Nothing => pure (pure Nothing)
--      putStrLn $ "Received " ++ show message
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
runProcess : Process iface () inState outState -> IO ()
runProcess process = do
  result <- runWithFuel infiniteFuel process
  putStrLn ("runProcess result: " ++ show result)
  pure ()

partial
main : IO ()
main = runProcess doMain
