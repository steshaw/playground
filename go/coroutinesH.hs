module Main where

import Text.Printf
import Control.Concurrent
import Control.Concurrent.Chan

expensiveComputation :: Int -> Int -> Int -> Chan Int -> IO ()
expensiveComputation x y z done = do
  threadDelay $ 3000 * 1000
  printf "x=%d, y=%d, y=%d\n"  x y z
  writeChan done 1

anotherExpensiveComputation :: String -> String -> String -> IO ()
anotherExpensiveComputation a b c = do
  threadDelay $ 2000 * 1000
  printf "a=%s, b=%s, c=%s\n" a b c

main = do
  let
    x = 1
    y = 2
    z = 3
  done <- newChan
  forkIO $ expensiveComputation x y z done
  let
    a = "at"
    b = "banana"
    c = "cat"
  anotherExpensiveComputation a b c
  i <- readChan done -- Wait for expensiveComputation to be complete before we quit.
  printf "bye done=%d\n" i
