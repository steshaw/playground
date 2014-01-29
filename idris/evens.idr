module Main

even       : Nat -> Bool
even Z     = True
even (S k) = odd k
  where
    odd       : Nat -> Bool
    odd Z     = False

    odd (S k) = even k

main : IO ()
main = do
  putStrLn $ show $ even Z
  putStrLn $ show $ even (S Z)
  putStrLn $ show $ even (S (S Z))
  putStrLn $ show $ even (S (S (S Z)))
