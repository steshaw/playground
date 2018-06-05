module Main

%default total

crew : List String
crew =
  [ "Lister"
  , "Rimmer"
  , "Kryten"
  , "Cat"
  ]

main : IO ()
main = do
  putStr "Display crew? "
  x <- getLine
  when (x == "yes") $ do
    traverse putStrLn crew
    pure ()
  putStrLn "Done"
