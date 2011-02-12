module Main where

import Control.Monad (mapM_)

($>) = flip ($)

start_year = 1901 -- When the "Commonwealth of Australia" officially starts.
this_year = 2011
years = (this_year - start_year)
percent = 0.02
begin_num = 100.0

gen n = num:(gen num)
  where num = n * (1 + percent)

main =
  take years (zip [start_year..] (gen begin_num))
    $> mapM_ (\(date,num) -> putStrLn ((show date) ++ "," ++ (show num)))
