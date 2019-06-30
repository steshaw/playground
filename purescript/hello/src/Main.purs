module Main where

import Prelude

import Control.Safely (replicateM_)
import Effect (Effect)
import Effect.Console (log)

times :: Int -> Effect Unit -> Effect Unit
times n action = replicateM_ n action
{-
times n action =
  if (n == 0)
  then log "done"
  else do
    action
    times (n-1) action
-}

main :: Effect Unit
main = times 10 $ log "Hello, PureScript!"
