|||
||| I was curious about the limits of process/thread creation.
||| On my MacBook this currently gives: "spawn failed at 2048".
||| I assume these are pthreads rather than lightweight user-space threads.
|||
module Main

import System
import System.Concurrency.Channels

hello : Nat -> IO ()
hello n = loop
  where
    loop = do
      putStrLn ("hello from " ++ show n)
      usleep (1 * 1000 * 1000)
      loop

create : Nat -> IO ()
create n = do
  Just helloPid <- spawn (hello n)
    | Nothing => putStrLn ("spawn failed at " ++ show n)
  printLn $ "spawned hello " ++ show n
  create (n + 1)

main : IO ()
main = create 1
