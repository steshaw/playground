module ArithState

import Data.Primitives.Views
import System

%default total

record Score where
  constructor MkScore
  correct : Nat
  attempted : Nat

record GameState where
  constructor MkGameState
  score : Score
  difficulty : Int

--
-- ### 12.3.3 Updating record field values
--

-- Using pattern matching only.
setDifficulty1 : Int -> GameState -> GameState
setDifficulty1 newDifficulty (MkGameState score _) =
  MkGameState score newDifficulty

-- Using `record` keyword.
setDifficulty : Int -> GameState -> GameState
setDifficulty newDifficulty state =
  record { difficulty = newDifficulty } state

-- Using pattern matching only.
addWrong1 : GameState -> GameState
addWrong1 (MkGameState (MkScore correct attempted) difficulty) =
  MkGameState (MkScore correct (attempted + 1)) difficulty

-- Using nested `record` blocks.
addWrong2 : GameState -> GameState
addWrong2 state = record {
  score = record {
    attempted = (attempted (score state)) + 1
  } (score state)
} state

-- Using record paths.
addWrong3 : GameState -> GameState
addWrong3 state = record {
  score->attempted = attempted (score state) + 1
} state

addWrong : GameState -> GameState
addWrong state = record {
  score->attempted $= (+ 1)
} state

addCorrect1 : GameState -> GameState
addCorrect1 state = record {
  score->correct = correct (score state) + 1,
  score->attempted = attempted (score state) + 1
} state

addCorrect : GameState -> GameState
addCorrect state = record {
  score->correct $= (+1),
  score->attempted $= (+1)
} state

initState : GameState
initState = MkGameState (MkScore 0 0) 12

Show GameState where
  show state =
    show (correct (score state)) ++ "/" ++
    show (attempted (score state)) ++ "\n" ++
    "Difficulty: " ++ show (difficulty state)

data Command : Type -> Type where
  PutStr : (msg : String) -> Command ()
  GetLine : Command String

  GetRandom : Command Int
  GetGameState : Command GameState
  PutGameState : GameState -> Command ()

  Pure : ty -> Command ty
  Bind : Command a -> (a -> Command b) -> Command b

%name Command command

data ConsoleIO : Type -> Type where
  Quit : a -> ConsoleIO a
  Do : Command a -> (a -> Inf (ConsoleIO b)) -> ConsoleIO b

namespace CommandDo
  (>>=) : Command a -> (a -> Command b) -> Command b
  (>>=) = Bind

namespace ConsoleDo
  (>>=) : Command a -> (a -> Inf (ConsoleIO b)) -> ConsoleIO b
  (>>=) = Do

mutual
  Functor Command where
    map f fa = do
      a <- fa
      pure $ f a

  Applicative Command where
    pure = Pure

    f <*> fa = do
      f <- f
      map f fa

  Monad Command where
    (>>=) = Bind

data Fuel = Dry | More (Lazy Fuel)

runCommand :
  Stream Int ->
  GameState ->
  Command a ->
  IO (a, Stream Int, GameState)
runCommand rnds state (PutStr msg) = do
  putStr msg
  pure ((), rnds, state)
runCommand rnds state GetLine = do
  line <- getLine
  pure (line, rnds, state)
runCommand (rnd :: rnds) state GetRandom =
  pure (getRandom rnd (difficulty state), rnds, state)
  where
    getRandom rnd max with (divides rnd max)
      getRandom rnd 0 | DivByZero = 1
      getRandom ((max * div) + rem) max | (DivBy prf) = abs rem + 1
runCommand rnds state GetGameState =
  pure (state, rnds, state)
runCommand rnds _ (PutGameState state) =
  pure ((), rnds, state)
runCommand rnds state (Pure val) =
  pure (val, rnds, state)
runCommand rnds state (Bind command f) = do
  (res, newRnds, newState) <- runCommand rnds state command
  runCommand newRnds newState (f res)

partial
forever : Fuel
forever = More forever

run :
  Fuel ->
  Stream Int ->
  GameState ->
  ConsoleIO a ->
  IO (Maybe a, Stream Int, GameState)
run fuel rnds state (Quit val) = pure (Just val, rnds, state)
run Dry rnds state (Do command f) = pure (Nothing, rnds, state)
run (More fuel) rnds state (Do command f) = do
  (res, newRnds, newState) <- runCommand rnds state command
  run fuel newRnds newState (f res)

data Input
  = Answer Int
  | QuitCmd

readInput : (prompt : String) -> Command Input
readInput prompt = do
  PutStr prompt
  answer <- GetLine
  if toLower answer == "quit"
    then Pure QuitCmd
    else Pure (Answer (cast answer))

mutual
  correct : ConsoleIO GameState
  correct = do
    PutStr "Correct!\n"
    state <- GetGameState
    PutGameState (addCorrect state)
    quiz

  wrong : Int -> ConsoleIO GameState
  wrong answer = do
    PutStr ("Wrong, the answer is " ++ show answer ++ "\n")
    state <- GetGameState
    PutGameState (addWrong state)
    quiz

  quiz : ConsoleIO GameState
  quiz = do
    num1 <- GetRandom
    num2 <- GetRandom
    state <- GetGameState
    PutStr (show state ++ "\n")

    input <- readInput (show num1 ++ " * " ++ show num2 ++ "? ")
    case input of
      Answer answer =>
        if answer == num1 * num2
        then correct
        else wrong (num1 * num2)
      QuitCmd => Quit state

randoms : Int -> Stream Int
randoms seed =
  let seed' = 1664525 * seed + 1013904223
  in (seed' `shiftR` 2) :: randoms seed'

partial
main : IO ()
main = do
  seed <- time
  (Just score, _, state) <-
    run forever (randoms (fromInteger seed)) initState quiz
      | _ => putStrLn "Ran out of fuel :("
  putStrLn ("Final score: " ++ show state)
