import Effects
import Effect.State

data BTree a
  = Leaf
  | Node (BTree a) a (BTree a)

implementation Show a => Show (BTree a) where
  show Leaf = "[]"
  show (Node l x r) = "[" ++ show l ++ " "
                          ++ show x ++ " "
                          ++ show r ++ "]"

testTree : BTree String
testTree = Node (Node Leaf "Jim" Leaf)
                "Fred"
                (Node (Node Leaf "Alice" Leaf)
                      "Sheila"
                      (Node Leaf "Bob" Leaf))

treeTagAux : (i : Int) -> BTree a -> (Int, BTree (Int, a))
treeTagAux i Leaf = (i, Leaf)
treeTagAux i (Node l x r) =
  let (i', l') = treeTagAux i l in
  let x' = (i', x) in
  let (i'', r') = treeTagAux (i' + 1) r in
    (i'', Node l' x' r')

treeTag : (i : Int) -> BTree a -> BTree (Int, a)
treeTag i x = snd (treeTagAux i x)

treeTagAuxE : BTree a -> Eff (BTree (Int, a)) [STATE Int]
treeTagAuxE Leaf = pure Leaf
treeTagAuxE (Node l x r) = do
  l' <- treeTagAuxE l
  i <- get
  put (i + 1)
  r' <- treeTagAuxE r
  pure (Node l' (i, x) r')

treeTagE : (i : Int) -> BTree a -> BTree (Int, a)
treeTagE i tree = runPureInit [i] $ treeTagAuxE tree

main : IO ()
main = printLn (treeTag 1 testTree)
