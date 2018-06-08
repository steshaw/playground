|||
||| ## 14.3 A verified guessing game: describing rules in types
|||
module Main

import Data.Vect

%default total

--
-- Previously we had:
--

namespace Previously

  data HangmanState : (guessesLeft : Nat) -> (lettersLeft : Nat) -> Type where
    MkHangmanState :
      {guessesLeft : Nat} ->
      (word : String) ->
      (missing : Vect lettersLeft Char) ->
      HangmanState guessesLeft lettersLeft

  %name HangmanState state, state1, state2, state3

  data Finished : Type where
    Lost : (game : HangmanState 0 (S lettersLeft)) -> Finished
    Won  : (game : HangmanState (S guessesLeft) 0) -> Finished

  game : HangmanState (S guesses) (S letters) -> IO Finished
  game state = pure (Lost (MkHangmanState "ANYTHING" ['a', 'b']))

--
-- Now let's encode the rules in the type:
--

data GameState : Type where
  NotRunning : GameState
  Running : (guessesLeft : Nat) -> (lettersLeft : Nat) -> GameState

letters : String -> List Char
letters str = nub (map toUpper (unpack str))

data GuessResult = Correct | Incorrect

data GameCmd : (ty : Type) -> GameState -> (ty -> GameState) -> Type where
  NewGame :
    (word : String) ->
    GameCmd () NotRunning (const (Running 6 (length (letters word))))
  Guess : (c : Char) -> GameCmd GuessResult (Running (S guessesLeft) (S lettersLeft))
    (\res => case res of
      Correct => Running (S guessesLeft) lettersLeft
      Incorrect => Running guessesLeft (S lettersLeft))
  Won : GameCmd () (Running (S guessesLeft) 0) (const NotRunning)
  Lost : GameCmd () (Running 0 (S guessesLeft)) (const NotRunning)

  ShowState : GameCmd () state (const state)
  Message : String -> GameCmd () state (const state)
  ReadGuess : GameCmd Char state (const state)

  Pure : (res : ty) -> GameCmd ty (stateFn res) stateFn
  (>>=) :
    GameCmd a state1 state2Fn ->
    ((res : a) -> GameCmd b (state2Fn res) state3Fn) ->
    GameCmd b state1 state3Fn

namespace Loop

  data GameLoop : (ty : Type) -> GameState -> (ty -> GameState) -> Type where
    Exit : GameLoop () NotRunning (const NotRunning)
    (>>=) :
      GameCmd a state1 state2Fn ->
      ((res : a) -> Inf (GameLoop b (state2Fn res) state3Fn)) ->
      GameLoop b state1 state3Fn

gameLoop : GameLoop () (Running (S guessesLeft) (S lettersLeft)) (const NotRunning)
gameLoop {guessesLeft} {lettersLeft} = do
  ShowState
  guess <- ReadGuess
  result <- Guess guess
  case result of
    Correct => case lettersLeft of
      Z => do
        Won
        ShowState
        Exit
      S k => do
        Message "Correct!"
        gameLoop
    Incorrect => case guessesLeft of
      Z => do
        Lost
        ShowState
        Exit
      S k => do
        Message "Incorrect!"
        gameLoop

hangman : GameLoop () NotRunning (const NotRunning)
hangman = do
  NewGame "testing"
  gameLoop

data Game : GameState -> Type where
  GameStart : Game NotRunning
  GameWon : (word : String) -> Game NotRunning
  GameLost : (word : String) -> Game NotRunning
  InProgress :
    (word : String) ->
    (guessesLeft : Nat) ->
    (missing : Vect lettersLeft Char) ->
    Game (Running guessesLeft lettersLeft)

Show (Game g) where
  show GameStart = "Starting"
  show (GameWon word) = "Game won: word was " ++ word
  show (GameLost word) = "Game lost: word was " ++ word
  show (InProgress word guessesLeft missing) =
    "\n" ++ pack (map hideMissing (unpack word)) ++
      "\n" ++ show guessesLeft ++ " guesses left"
    where
      hideMissing : Char -> Char
      hideMissing c = if c `elem` missing then '-' else c

data Fuel = Dry | More (Lazy Fuel)

data GameResult : (ty : Type) -> (ty -> GameState) -> Type where
  OK :
    (res : ty) ->
    Game (outStateFn res) ->
    GameResult ty outStateFn
  OutOfFuel : GameResult ty outStateFn

ok :
  (res : ty) ->
  Game (outstate_fn res) ->
  IO (GameResult ty outstate_fn)
ok res st = pure (OK res st)

removeElem :
  (x : a) ->
  (xs : Vect (S n) a) ->
  {auto prf : Elem x xs} ->
  Vect n a
removeElem x (x :: ys) {prf = Here} = ys
removeElem x (y :: []) {prf = There later} {n = Z} = absurd later
removeElem x (y :: ys) {prf = There later} {n = (S k)} = y :: removeElem x ys

runCmd :
  Fuel ->
  Game inState ->
  GameCmd ty inState outStateFn ->
  IO (GameResult ty outStateFn)
runCmd fuel game (NewGame word) =
  ok () (InProgress (toUpper word) _ (fromList (letters word)))
runCmd fuel (InProgress word _ missing) (Guess c) = do
  case isElem c missing of
    Yes prf => ok Correct (InProgress word _ (removeElem c missing))
    No contra => ok Incorrect (InProgress word _ missing)
runCmd fuel (InProgress word (S guessesLeft) missing) Won =
  ok () (GameWon word)
runCmd fuel (InProgress word _ missing) Lost =
  ok () (GameLost word)
runCmd fuel game ShowState = do
  printLn game
  ok () game
runCmd fuel game (Message x) = do
  putStrLn x
  ok () game
runCmd Dry game ReadGuess = pure OutOfFuel
runCmd (More fuel) game ReadGuess = do
  putStr "Guess: "
  line <- getLine
  case unpack line of
    [c] => if isAlpha c
           then ok (toUpper c) game
           else do
             putStrLn "Invalid input"
             runCmd fuel game ReadGuess
    _ => do
      putStrLn "Invalid input"
      runCmd fuel game ReadGuess
runCmd fuel game (Pure res) = ok res game
runCmd fuel game (cmd >>= cont) = do
  OK result newState <- runCmd fuel game cmd
    | OutOfFuel => pure OutOfFuel
  runCmd fuel newState (cont result)

run :
  Fuel ->
  Game inState ->
  GameLoop ty inState outStateFn ->
  IO (GameResult ty outStateFn)
run Dry state gameLoop = pure OutOfFuel
run (More x) state Exit = ok () state
run (More fuel) state (cmd >>= cont) = do
  OK result newState <- runCmd fuel state cmd
    | OutOfFuel => pure OutOfFuel
  run fuel newState (cont result)

partial
forever : Fuel
forever = More forever

partial
main : IO ()
main = do
  run forever GameStart hangman
  pure ()
