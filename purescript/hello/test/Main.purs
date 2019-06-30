module Test.Main where

import Prelude

import Effect.Console (log)
import Euler (answer)
import Test.Assert (assert)

main = do
  log "Executing Test.Main.main"
  assert (answer == 233168)
