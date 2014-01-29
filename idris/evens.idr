module Main

mutual
  even       : Nat -> Bool
  even Z     = True
  even (S k) = odd k

  odd       : Nat -> Bool
  odd Z     = False
  odd (S k) = even k

main : IO ()
main = do
  putStrLn $ show $ even Z
  putStrLn $ show $ odd Z
  putStrLn $ show $ even (S Z)
  putStrLn $ show $ odd (S Z)
  putStrLn $ show $ even (S (S Z))
  putStrLn $ show $ odd (S (S Z))
  putStrLn $ show $ even (S (S (S Z)))
  putStrLn $ show $ odd (S (S (S Z)))
