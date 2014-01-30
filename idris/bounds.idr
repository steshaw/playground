module Main

inBounds : Int -> Int -> Bool
inBounds x y = x >= 0 && x < 640 && y >=0 && y < 480

unsafeDrawPoint : (Show x, Show y) => x -> y -> IO ()
unsafeDrawPoint x y = do
  putStr "("
  putStr (show x)
  putStr " "
  putStr (show y)
  putStr ")"
  putStrLn ""

drawPoint : (x : Int) -> (y : Int) -> {default oh p : so (inBounds x y)} -> IO ()
drawPoint x y = unsafeDrawPoint x y

main : IO ()
main = do
  drawPoint 0 0
  drawPoint (640-1) (480-1)
