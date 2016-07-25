import Effects
import Effect.Select
import Effect.Exception

triple : Int -> Eff (Int, Int, Int) [SELECT, EXCEPTION String]
triple max = do
  z <- select [1..max]
  y <- select [1..z]
  x <- select [1..y]
  if (x * x + y * y == z * z)
    then pure (x, y, z)
    else raise "No triple"

main : IO ()
main = do
  printLn $ the (Maybe _) $ run (triple 100)
  printLn $ the (List _) $ run (triple 100)
