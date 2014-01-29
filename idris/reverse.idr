module Main

rev : List a -> List a
rev xs = revAcc [] xs where
  revAcc : List a -> List a -> List a
  revAcc acc []        = acc
  revAcc acc (x :: xs) = revAcc (x :: acc) xs

main : IO ()
main = putStrLn $ show $ rev [1..7]
