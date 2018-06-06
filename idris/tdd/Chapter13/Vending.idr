--
-- ### 13.1.3 Infinite states: modeling a vending machine
--

module Vending

%default total

VendState : Type
VendState = (Nat, Nat)

data Input
  = COIN
  | VEND
  | CHANGE
  | REFILL Nat

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
  Do :
    MachineCmd a state1 state2 ->
    (a -> Inf (MachineIO state2)) ->
    MachineIO state1

namespace MachineDo
  (>>=) :
    MachineCmd a state1 state2 ->
    (a -> Inf (MachineIO state2)) ->
    MachineIO state1
  (>>=) = Do

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
