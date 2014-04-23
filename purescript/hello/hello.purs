module Main where

import Control.Monad.Eff
import Debug.Trace

--times :: forall a b e. Eff e a -> Eff e b
--times :: forall a b e. Number -> Eff e a -> Eff e b
times n action =
  if (n == 0)
  then trace "done"
  else do
    action
    times (n-1) action

main = times 10 $ trace "Hello, PureScript!"
