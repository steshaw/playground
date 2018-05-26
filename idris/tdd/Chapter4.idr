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

data MyNat = Z | S MyNat

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

--
-- 4.2 Defining dependent data types
--

data PowerSource = Petrol | Pedal | Electric

data Vehicle : PowerSource -> Type where
  Unicycle : Vehicle Pedal
  Bicycle : Vehicle Pedal
  Car : (fuel : Nat) -> Vehicle Petrol
  ElectricCar : (fuel : Nat) -> Vehicle Electric
  Motocycle : (fuel : Nat) -> Vehicle Petrol
  Bus : (fuel : Nat) -> Vehicle Petrol
  Tram : Vehicle Electric

wheels : Vehicle _ -> Nat
wheels Unicycle = 1
wheels Bicycle = 2
wheels (Car fuel) = 4
wheels (ElectricCar fuel) = 4
wheels (Motocycle fuel) = 2
wheels (Bus fuel) = 4
wheels Tram = 4

-- Problem: Electric cars can be refuel in addition to petrol ones.
-- However, electric trams do not need refueling. So, our current model
-- doesn't reflect reality very well...
refuel : Vehicle Petrol -> Vehicle Petrol
refuel (Car fuel) = Car 100
refuel (Motocycle fuel) = Car 80
refuel (Bus fuel) = Bus 200
refuel Unicycle impossible
refuel Bicycle impossible

{-
Type parameters and indices

- "A parameter is unchanged across the entire structure".
  They are "parametric" (as in "parametricity").
- "An index may change across a structure".

I don't like this definition of the distinction (it's a bit hard to say why).
i.e. that it's about "changing across the structure (or not)". Looks like you
can pattern match on an index by not a parameter (recall the "free thereoms"
from parametricity due to that). And yet I recall Conor saying that we
ought to be able to choose when we can pattern match on types too.

I recall that Idris infers which arguments in a data type definitino are
indices and which are parameters. Perhaps there's something of a distinction
could be gathered from the description of the inference algorithm.

See "Terminology: parameters and indices" on p105.
-}

-- Vect is indexed by length and parameterised by elemType.
data Vect : (length: Nat) -> (elemType : Type) -> Type where
  Nil : Vect Z a
  (::) : (x : a) -> (xs : Vect k a) -> Vect (S k) a

%name Vect xs, ys, zs

append : Vect n elem -> Vect m elem -> Vect (n + m) elem
append [] ys = ys
append (x :: xs) ys = x :: append xs ys

zip : Vect n a -> Vect n b -> Vect n (a, b)
zip [] [] = []
zip (x :: xs) (y :: ys) = (x, y) :: zip xs ys
