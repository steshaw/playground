module Euler where

import Prelude

import Data.Foldable (sum)
import Data.List (range, filter)
import Effect.Console (log)

ns = range 0 999

multiples = filter (\n -> mod n 3 == 0 || mod n 5 == 0) ns

answer = sum multiples

main = log $ show answer
