import Control.Monad.State.Lazy
 
data Tree a = Leaf a | Branch (Tree a) (Tree a) deriving Show
 
number :: Int -> Tree a -> (Tree (a, Int),Int)
number seed (Leaf a) = (Leaf (a, seed), seed + 1)
number seed (Branch left right)
 = let (l, ls) = number seed left
       (r, rs) = number ls right
   in
       (Branch l r, rs)
 
numbers :: Tree a -> State Int (Tree (a, Int))
numbers (Leaf a) = do n <- get
                      modify (+1)
                      return (Leaf (a, n))
 
numbers (Branch l r) = do left <- numbers l
                          right <- numbers r
                          return (Branch left right)
 
initState :: State s s
initState = State (\s -> (s, s))

-- test function
main =
  let t = Branch (Branch (Leaf 1) (Leaf 2)) (Leaf 3) in
  putStrLn $ show $ evalState (numbers t) 10
