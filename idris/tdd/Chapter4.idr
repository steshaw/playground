|||
||| User-defined data types
|||
||| 1. Enumerated types – Types defined by giving the possible values directly
||| 2. Union types – Enumerated types that carry additional data with each value
||| 3. Recursive types – Union types that are defined in terms of themselves
||| 4. Generic/Parameterised types – Types that are parameterised over some other types
||| 5. Dependent types — Types that are computed from some other value
|||
module Chapter4

%default total

||| Represents shapes
data Shape
  = ||| A triangle, with its base length and height
    Triangle Double Double
  | ||| A rectangle, with its length and height
    Rectangle Double Double
  | ||| A circle, with its radius
    Circle Double

namespace Natural
  data Nat = Z | S Natural.Nat

data Infinite = Forever Infinite

data Tree t
  = Empty
  | Node (Tree t) t (Tree t)

%name Tree tree, tree1, tree2, tree3

insert : Ord elem => elem -> Tree elem -> Tree elem
insert x Empty = Node Empty x Empty
insert x node@(Node left val right) =
  case compare x val of
    LT => Node (insert x left) val right
    EQ => node
    GT => Node left val (insert x right)

namespace BinarySearch
  data BSTree : Type -> Type where
    Empty : Ord elem => BSTree elem
    Node : Ord elem =>
      (left : BSTree elem) ->
      (val : elem) ->
      (right : BSTree elem) ->
      BSTree elem

  %name BSTree tree, tree1, tree2, tree3

  insert : elem -> BSTree elem -> BSTree elem
  insert x Empty = Node Empty x Empty
  insert x node@(Node left val right) =
    case compare x val of
      LT => Node (insert x left) val right
      EQ => node
      GT => Node left val (insert x right)

listToTree : Ord a => List a -> Tree a
listToTree [] = Empty
listToTree (x :: xs) = insert x $ listToTree xs

treeToList : Tree a -> List a
treeToList Empty = []
treeToList (Node left val right) = treeToList left ++ [val] ++ treeToList right

data Expr
  = EInt Int
  | Add Expr Expr
  | Sub Expr Expr
  | Mul Expr Expr

%name Expr expr, expr1, expr2, expr3

evaluate : Expr -> Int
evaluate (EInt i) = i
evaluate (Add l r) = evaluate l + evaluate r
evaluate (Sub l r) = evaluate l - evaluate r
evaluate (Mul l r) = evaluate l * evaluate r

maxMaybe : Ord a => Maybe a -> Maybe a -> Maybe a
maxMaybe Nothing Nothing = Nothing
maxMaybe Nothing x = x
maxMaybe x Nothing = x
maxMaybe (Just x) (Just y) = Just $ max x y
