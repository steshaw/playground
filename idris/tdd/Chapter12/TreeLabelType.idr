module TreeLabelType

%default total

data Tree a
  = Empty
  | Node (Tree a) a (Tree a)

%name Tree tree, tree1, tree2, tree3

testTree : Tree String
testTree =
  Node
    (Node
      (Node Empty "Jim" Empty) "Fred"
      (Node Empty "Sheila" Empty)) "Alice"
    (Node Empty "Bob" (Node Empty "Eve" Empty))

flatten : Tree a -> List a
flatten Empty = []
flatten (Node left val right) = flatten left ++ val :: flatten right

data State : (stateType : Type) -> Type -> Type where
  Get : State stateType stateType
  Put : stateType -> State stateType ()

  Pure : ty -> State stateType ty
  Bind : State stateType a -> (a -> State stateType b) -> State stateType b

get : State stateType stateType
get = Get

put : stateType -> State stateType ()
put = Put

pure : ty -> State stateType ty
pure = Pure

(>>=) : State stateType a -> (a -> State stateType b) -> State stateType b
(>>=) = Bind

treeLabelWith : Tree a -> State (Stream labelType) (Tree (labelType, a))
treeLabelWith Empty = pure Empty
treeLabelWith (Node left val right) = do
  leftResult <- treeLabelWith left
  (vLabel :: labels) <- get
  put labels
  rightResult <- treeLabelWith right
  pure $ Node leftResult (vLabel, val) rightResult

runState : State stateType a -> (st : stateType) -> (a, stateType)
runState Get st = (st, st)
runState (Put newState) st = ((), newState)
runState (Pure x) st = (x, st)
runState (Bind action cont) st =
  let (val, nextState) = runState action st
  in runState (cont val) nextState

treeLabel : Tree a -> Tree (Integer, a)
treeLabel tree = fst $ runState (treeLabelWith tree) [1..]
