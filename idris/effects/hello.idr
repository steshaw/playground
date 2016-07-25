module Main

import Effects
import Effect.StdIO
import Effect.State

Hello : Type
Hello = Eff () [STDIO, 'Line ::: STATE Int]

hello : Hello
hello = do
  putStrLn "Hello world!"

main : IO ()
main = runInit [(), 'Line := 99] hello
