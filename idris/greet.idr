module Main

greet : IO ()
greet = do
  putStr "What is your name? "
  name <- getLine
  putStrLn $ "name = [[" ++ show name ++ "]]"
  putStr $ "Hello " ++ name

main : IO ()
main = greet
