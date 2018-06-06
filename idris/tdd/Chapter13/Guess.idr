module Guess

data GuessCmd : Type -> Nat -> Nat -> Type where
  Try : Integer -> GuessCmd Ordering (1 + guesses) guesses
  Pure : ty -> GuessCmd ty state state
  (>>=) :
    GuessCmd a state1 state2 ->
    (a -> GuessCmd b state2 state3) ->
    GuessCmd b state1 state3

threeGuesses: GuessCmd () 3 0
threeGuesses = do
  Try 10
  Try 20
  Try 15
  Pure ()

-- This isn't supposed to type check.
{-
noGuesses : GuessCmd () 0 0
noGuesses = do
  Try 10
  Pure ()
-}
