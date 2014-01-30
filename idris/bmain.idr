module Main

import btree

main : IO ()
main = do
  print (btree.toList (toTree [1,8,2,7,9,3]))
