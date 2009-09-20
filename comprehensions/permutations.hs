import Data.List

permutation :: Eq a => [a] -> [[a]]
permutation [] = [[]]
permutation xs = [x:ys | x <- xs, ys <- permutation (delete x xs)]

main = putStrLn $ show $ permutation [1,2,3]
