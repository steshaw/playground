import Control.Monad
import System.Environment

tokens = [('[',']'), ('(',')')]

parse [] = Just []
parse (c:cs) = case lookup c tokens of
  Nothing -> return (c:cs)
  Just end -> parse cs >>= consume end >>= parse

consume c [] = Nothing
consume c (x:xs) = guard (c == x) >> return xs

main = getArgs >>= mapM (print . maybe False null . parse)
