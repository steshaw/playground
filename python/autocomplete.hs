--
-- Port to Haskell of original Python code from
--
--   http://williamedwardscoder.tumblr.com/post/18319031919/programming-language-readability
--

{-
 - A fast data structure for searching strings with autocomplete support.
 -}
module Trie where

import qualified Data.Map as M

data Trie = 
  Trie { value :: String
       , children :: M.Map Char Trie
       , terminates :: Bool
       }
  deriving (Show, Eq)

empty :: Trie
empty = Trie {value = "", children = M.empty, terminates = False}

insert :: String -> Trie -> Trie
insert [] t = t { value = value t, terminates = True }
insert (k:ks) t =
  let cs = children t
  in case M.lookup k cs of
        Nothing -> t { children = M.insert k (insert ks child) cs }
                   where child = empty {value = value t ++ [k]}
        Just t' -> t { children = M.insert k (insert ks t') cs }

findNode :: String -> Trie -> Maybe Trie
findNode [] t = Just $ t
findNode (k:ks) t =
  M.lookup k (children t) >>= \t' -> 
    findNode ks t'

find :: String -> Trie -> Maybe String
find w t = findNode w t >>= \t' ->
  if terminates t' then Just $ value t' else Nothing

allPrefixes :: Trie -> [String]
allPrefixes t =
  if terminates t
  then value t : cs else cs
  where
    cs = M.fold f [] (children t)
    f n as = as ++ (allPrefixes n)

autoComplete :: String -> Trie -> [String]
autoComplete prefix t = 
  case findNode prefix t of
    Nothing -> []
    Just n -> allPrefixes n

cities =
  [ "New York"
  , "New Jersey"
  , "New Orleans"
  , "San Fransisco"
  , "New Hampshire"
  , "Boston"
  ]

citrie = foldr insert empty cities
