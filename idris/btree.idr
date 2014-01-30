module btree

data BTree a
  = Leaf
  | Node (BTree a) a (BTree a)

insert : Ord a => a -> BTree a -> BTree a
insert i Leaf                = Node Leaf i Leaf
insert i (Node left a right) =
  if i < a
  then Node (insert i left) a right
  else Node left a (insert i right)

toList : BTree a -> List a
toList Leaf = Nil
toList (Node left a right) = btree.toList left ++ [a] ++ btree.toList right

toTree : Ord a => List a -> BTree a
toTree Nil       = Leaf
toTree (x :: xs) = insert x (toTree xs)
