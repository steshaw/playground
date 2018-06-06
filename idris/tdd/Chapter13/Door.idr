|||
||| ## 13.1 State machines: tracking state in types
|||
module Door

data DoorState = DoorClosed | DoorOpen

data DoorCmd :
  Type ->
  DoorState ->
  DoorState ->
  Type
where
  Open : DoorCmd () DoorClosed DoorOpen
  Close : DoorCmd () DoorOpen DoorClosed
  RingBell : DoorCmd () state state

  Pure : ty -> DoorCmd ty state state
  (>>=) :
    DoorCmd a state1 state2 ->
    (a -> DoorCmd b state2 state3) ->
    DoorCmd b state1 state3

doorProg1 : DoorCmd () DoorClosed DoorClosed
doorProg1 = do
  RingBell
  Open
  Close

{-
doorProgBad : DoorCmd () DoorClosed ?stateAfter
doorProgBad = do
  Open
  Open
  RingBell
-}

doorProg2 : DoorCmd () DoorClosed DoorClosed
doorProg2 = do
  RingBell
  Open
  RingBell
  Close
