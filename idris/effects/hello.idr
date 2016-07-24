module Main

import Effects
import Effect.StdIO

Hello : Type
Hello = Eff () [STDIO]

hello : Hello
hello = putStrLn "Hello world!"

main : IO ()
main = run hello
