module Main where

import Control.Monad (mapM_)

($>) = flip ($)

gen n = num:(gen num)
  where num = n * 1.02

main = take 25 (zip [1980..] (gen 100.00)) $> mapM_ (\(date,num) -> putStrLn ((show date) ++ "," ++ (show num)))
