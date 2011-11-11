--
-- Adapted from http://blog.tmorris.net/haskell-scala-java-7-functional-java-java/#comment-12248
--
-- * fixed bug by adding 'many $'
-- * removed the odd-looking "return ' '"
--

import Control.Monad
import Text.ParserCombinators.Parsec
import System

pArg = many $
     do char '('; pArg; char ')'
 <|> do char '['; pArg; char ']'

testArg = either (const False) (const True) . parse (pArg >> eof) ""

good = 
  [ ""
  , "()"
  , "[]"
  , "([])"
  , "[()]"
  , "[]()"
  , "[][[([])]]"
  ]

bad =
  [ "("
  , ")"
  , "["
  , "]"
  , "]["
  , ")("
  , "( )"
  , "([)"
  , "[)]"
  , "([)]"
  , "({})"
  , "[())]"
  ]

test = print $ 
  (map testArg good,
   map testArg bad)

main = getArgs >>= print . fmap testArg
