module ATM

import Data.Vect

%default total

PIN : Type
PIN = Vect 4 Char

data ATMState = Ready | CardInserted | Session

data PINCheck = CorrectPIN | IncorrectPIN

data HasCard : ATMState -> Type where
  HasCardInserted : HasCard CardInserted
  HasSession : HasCard Session

data ATMCmd :
  (ty : Type) ->
  ATMState ->
  (ty -> ATMState) ->
  Type
where
  InsertCard : ATMCmd () Ready (const CardInserted)
  EjectCard : {auto hasCard : HasCard state} -> ATMCmd () state (const Ready)
  GetPIN : ATMCmd PIN CardInserted (const CardInserted)

  CheckPIN : PIN -> ATMCmd PINCheck CardInserted
    (\check => case check of
      CorrectPIN => Session
      IncorrectPIN => CardInserted)
  GetAmount : ATMCmd Nat state (const state)

  Dispense : (amount : Nat) -> ATMCmd () Session (const Session)

  Message : String -> ATMCmd () state (const state)

  Pure : (res : ty) -> ATMCmd ty (stateFn res) stateFn
  (>>=) :
    ATMCmd a state1 state2Fn ->
    ((res : a) -> ATMCmd b (state2Fn res) state3Fn) ->
    ATMCmd b state1 state3Fn

%name ATMCmd cmd

atm : ATMCmd () Ready (const Ready)
atm = do
  InsertCard
  pin <- GetPIN
  pinOK <- CheckPIN pin
  Message "Checking card..."
  case pinOK of
    CorrectPIN => do
      cash <- GetAmount
      Dispense cash
      EjectCard
      Message "Please remove your card and cash"
    IncorrectPIN => do
      Message "Incorrect PIN"
      EjectCard

-- This program is now rejected.
{-
badATM : ATMCmd () Ready (const Ready)
badATM = EjectCard
-}

testPIN : Vect 4 Char
testPIN = ['1', '2', '3', '4']

readVect : (n : Nat) -> IO (Vect n Char)
readVect Z = do
  getLine
  pure [] -- XXX: weird
readVect (S k) = do
  c <- getChar
  cs <- readVect k
  pure (c :: cs)

runATM : ATMCmd res inState outState_fn -> IO res
runATM InsertCard = do
  putStrLn "Please insert your card (i.e. press enter)"
  getLine -- ignoring result
  pure ()
runATM EjectCard = putStrLn "Card ejected"
runATM GetPIN = do
  putStrLn "Enter PIN: "
  readVect 4
runATM (CheckPIN pin) =
  if pin == testPIN
  then pure CorrectPIN
  else pure IncorrectPIN
runATM GetAmount = do
  putStrLn "How much would you like? "
  line <- getLine
  pure (cast line)
runATM (Dispense amount) = putStrLn ("Here is " ++ show amount)
runATM (Message msg) = putStrLn msg
runATM (Pure res) = pure res
runATM (cmd >>= f) = do
  result <- runATM cmd
  runATM (f result)
