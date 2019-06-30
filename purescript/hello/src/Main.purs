module Main where

import Prelude

import Control.Safely (replicateM_)
import Effect (Effect)
import Effect.Console (log)

times :: Int -> Effect Unit -> Effect Unit
times n action = replicateM_ n action

-- Potential stack overflow can happen with large values of n.
timesSO :: Int -> Effect Unit -> Effect Unit
timesSO n action =
  if (n == 0)
  then log "done" -- FIXME: Not seeing "done".
  else do
    action
    times (n-1) action

main :: Effect Unit
main = do
  let n = 2147483647

  log "times 10"
  times 10 $ log "Hello, PureScript!"
  log $ "timesSO 10"
  timesSO 10 $ log "Hello, PureScript!"

  log $ "times " <> show n
  times n $ pure unit
  log $ "timesSO " <> show n
  timesSO n $ pure unit
