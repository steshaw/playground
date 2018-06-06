--
-- ### 13.1.3 Infinite states: modeling a vending machine
--

module Main

%default total

VendState : Type
VendState = (Nat, Nat)

data Input
  = COIN
  | VEND
  | CHANGE
  | REFILL Nat
  | EXIT

strToInput : String -> Maybe Input
strToInput "insert" = Just COIN
strToInput "vend" = Just VEND
strToInput "change" = Just CHANGE
strToInput "exit" = Just EXIT
strToInput "quit" = Just EXIT
strToInput s =
  if all isDigit (unpack s)
  then Just (REFILL (cast s))
  else Nothing

data MachineCmd :
  Type ->
  VendState ->
  VendState ->
  Type
where
  InsertCoin : MachineCmd () (pounds, chocs) (1 + pounds, chocs)
  Vend : MachineCmd () (1 + pounds, 1 + chocs) (pounds, chocs)
  GetCoins : MachineCmd () (pounds, chocs) (0, chocs)
  Refill : (bars : Nat) -> MachineCmd () (0, chocs) (0, bars + chocs)

  Display : String -> MachineCmd () state state
  GetInput : MachineCmd (Maybe Input) state state

  Pure : ty -> MachineCmd ty state state
  (>>=) :
    MachineCmd a state1 state2 ->
    (a -> MachineCmd b state2 state3) ->
    MachineCmd b state1 state3

data MachineIO : VendState -> Type where
  Quit : MachineIO state
  Do :
    MachineCmd a state1 state2 ->
    (a -> Inf (MachineIO state2)) ->
    MachineIO state1 -- <<- why is this `state1` rather than `state2`?

namespace MachineDo
  (>>=) :
    MachineCmd a state1 state2 ->
    (a -> Inf (MachineIO state2)) ->
    MachineIO state1
  (>>=) = Do

runMachine : MachineCmd ty inState outState -> IO ty
runMachine InsertCoin = putStrLn "Coin inserted"
runMachine Vend = putStrLn "Please take your chocolate"
runMachine GetCoins {inState = (pounds, chocs)} = do
  putStrLn (show pounds ++ " coins returned")
runMachine (Refill bars) = do
  putStrLn ("Chocolate remaining: " ++ show bars)
runMachine (Display msg) = putStrLn msg
runMachine GetInput {inState = (pounds, chocs)} = do
  putStrLn ("Coins: " ++ show pounds ++ "; " ++ "Stock: " ++ show chocs)
  putStr "> "
  line <- getLine
  pure (strToInput line)
runMachine (Pure x) = pure x
runMachine (action >>= cont) = do
  v <- runMachine action
  runMachine (cont v)

data Fuel = Dry | More (Lazy Fuel)

partial
forever : Fuel
forever = More forever

run : Fuel -> MachineIO state -> IO ()
run Dry y = pure ()
run (More fuel) (Do cmd cont) = do
  v <- runMachine cmd
  run fuel (cont v)
run (More _) Quit = putStrLn "quitting..."

mutual
  vend : MachineIO (pounds, chocs)
  vend {pounds = Z} {chocs = chocs} = do
    Display "Insert a coin"
    machineLoop
  vend {pounds = (S k)} {chocs = Z} = do
    Display "Out of stock"
    machineLoop
  vend {pounds = (S k)} {chocs = (S j)} = do
    Vend
    Display "Enjoy!"
    machineLoop

  refill : (num : Nat) -> MachineIO (pounds, chocs)
  refill num {pounds = Z} = do
    Refill num
    machineLoop
  refill num {pounds = (S k)} = do
    Display "Can't refill: coins in machine"
    machineLoop

  machineLoop : MachineIO (pounds, chocs)
  machineLoop = do
    Just input <- GetInput
      | Nothing => do
          Display "Invalid input"
          machineLoop
    case input of
      COIN => do
        InsertCoin
        machineLoop
      VEND => vend
      CHANGE => do
        GetCoins
        Display "Change returned"
        machineLoop
      REFILL num => refill num
      EXIT => Quit

partial
main : IO ()
main = do
  result <- run forever (machineLoop {pounds = 0} {chocs = 1})
  putStrLn $ "Final result = " ++ show result
