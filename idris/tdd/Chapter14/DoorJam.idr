|||
||| ## 14.1 Dealing with errors in state transitions
|||
module DoorJam

%default total

data DoorState = DoorClosed | DoorOpen

data DoorResult = OK | Jammed

data DoorCmd :
  (ty : Type) ->
  DoorState ->
  (ty -> DoorState) ->
  Type
where
  Open : DoorCmd DoorResult DoorClosed (\res => case res of
    OK => DoorOpen
    Jammed => DoorClosed)
  Close : DoorCmd () DoorOpen (const DoorClosed)
  RingBell : DoorCmd () DoorClosed (const DoorClosed)

  Display : String -> DoorCmd () state (const state)

  Pure : (res : ty) -> DoorCmd ty (stateFn res) stateFn
  (>>=) :
    DoorCmd a state1 state2Fn ->
    ((res : a) -> DoorCmd b (state2Fn res) state3Fn) ->
    DoorCmd b state1 state3Fn

doorProg : DoorCmd () DoorClosed (const DoorClosed)
doorProg = do
  RingBell
  jam <- Open
  case jam of
    OK => do
      Display "Glad to be of service"
      Close
    Jammed => Display "Door Jammed"

doorProg2 : DoorCmd () DoorClosed (const DoorClosed)
doorProg2 = do
  RingBell
  OK <- Open
    | Jammed => Display "Door Jammed"
  Display "Glad to be of service"
  Close
