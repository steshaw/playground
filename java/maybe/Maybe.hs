data Person = Person { name :: String, age :: Int }
  deriving (Show)

couldBePerson couldBeName couldBeAge =
  couldBeName >>= \name ->
  couldBeAge >>= \age ->
  Just (Person name age)

main = do
  putStrLn $ show $ couldBePerson (Just "Fred") (Just 25)
  putStrLn $ show $ couldBePerson Nothing (Just 3)
  putStrLn $ show $ couldBePerson (Just "Fred") Nothing
  putStrLn $ show $ couldBePerson Nothing Nothing
