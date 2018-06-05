|||
||| # 12 Writing programs with state
|||
module Chapter12

import Control.Monad.State

---
--- ## 12.1 Working with mutable state
---

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

treeLabelWith1 :
  Stream labelType ->
  Tree a ->
  (Stream labelType, Tree (labelType, a))
treeLabelWith1 labels Empty = (labels, Empty)
treeLabelWith1 labels (Node left v right) =
  let
    (vLabel :: labels, leftResult) = treeLabelWith1 labels left
    vResult = (vLabel, v)
    (labels, rightResult) = treeLabelWith1 labels right
  in (labels, Node leftResult vResult rightResult)

treeLabel1 : Tree a -> Tree (Integer, a)
treeLabel1 tree = snd $ treeLabelWith1 [1..] tree

increase1 : Nat -> State Nat ()
increase1 inc = do
  current <- get
  put (current + inc)

treeLabelWith2 : Tree a -> State (Stream labelType) (Tree (labelType, a))
treeLabelWith2 Empty = pure Empty
treeLabelWith2 (Node left val right) = do
  leftResult <- treeLabelWith2 left
  (vLabel :: labels) <- get
  put labels
  rightResult <- treeLabelWith2 right
  pure $ Node leftResult (vLabel, val) rightResult

treeLabel2 : Tree a -> Tree (Integer, a)
treeLabel2 tree = evalState (treeLabelWith2 tree) [1..]

--
-- Exercises
--

update1 : (stateType -> stateType) -> State stateType ()
update1 f = do
  current <- get
  put $ f current

update2 : (stateType -> stateType) -> State stateType ()
update2 = modify

increase2 : Nat -> State Nat ()
increase2 n = update2 (+ n)

countEmpty : Tree a -> State Nat ()
countEmpty Empty = update2 (+ 1)
countEmpty (Node left v right) = do
  countEmpty left
  countEmpty right

countEmptyNode : Tree a -> State (Nat, Nat) ()
countEmptyNode Empty = update2 $ \(empties, nodes) =>
  (empties + 1, nodes)
countEmptyNode (Node left v right) = do
  countEmptyNode left
  countEmptyNode right
  update2 $ \(empties, nodes) => (empties, nodes + 1)
