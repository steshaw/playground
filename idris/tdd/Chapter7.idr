module Main -- Chapter7

occurrences : Eq ty => (item : ty) -> (values : List ty) -> Nat
occurrences item [] = 0
occurrences item (x :: xs) = case item == x of
                                  False => occurrences item xs
                                  True => 1 + occurrences item xs

data Matter = Solid | Liquid | Gas

implementation Eq Matter where
  (==) Solid Solid = True
  (==) Liquid Liquid = True
  (==) Gas Gas = True
  (==) _ _ = False

data Tree elem
  = Empty
  | Node (Tree elem) elem (Tree elem)

%name Tree tree, tree1, tree2, tree3

implementation Eq elem => Eq (Tree elem) where
  Empty == Empty = True
  (Node xltree x xrtree) == (Node yltree y yrtree) =
    xltree == yltree && x == y && xrtree == yrtree
  _ == _ = False

record Album where
  constructor MkAlbum
  artist : String
  title : String
  year : Integer

help : Album
help = MkAlbum "The Beatles" "Help!" 1965

rubberSoul : Album
rubberSoul = MkAlbum "The Beatles" "Rubber Soul" 1965

clouds : Album
clouds = MkAlbum "Joni Mitchell" "Clouds" 1969

hunkyDory : Album
hunkyDory = MkAlbum "David Bowie" "Hunky Dory" 1971

heroes : Album
heroes = MkAlbum "David Bowie" "Heroes" 1977

collection : List Album
collection = [help, rubberSoul, clouds, hunkyDory, heroes]

Eq Album where
  (==) (MkAlbum artist title year) (MkAlbum artist2 title2 year2) =
    artist == artist2 && title == title2 && year == year2

Ord Album where
  compare (MkAlbum artist title year) (MkAlbum artist1 title1 year1) =
    compare (artist, year, title) (artist1, year1, title1)

Show Album where
  show (MkAlbum artist title year) =
    title ++ " by " ++ artist ++ " (released " ++ show year ++ ")"

data Shape
  = Triangle Double Double
  | Rectangle Double Double
  | Circle Double

Eq Shape where
  (==) (Triangle x z) (Triangle y w) = (x, z) == (y, w)
  (==) (Rectangle x z) (Rectangle y w) = (x, z) == (y, w)
  (==) (Circle x) (Circle y) = x == y
  (==) _ _ = False

area : Shape -> Double
area (Triangle base height) = (base * height) / 2
area (Rectangle length height) = length * height
area (Circle radius) = pi * radius * radius

Ord Shape where
  compare shape1 shape2 = compare (area shape1) (area shape2)

testShapes : List Shape
testShapes =
  [ Circle 3
  , Triangle 3 9
  , Rectangle 2 6
  , Circle 4
  , Rectangle 2 7
  ]

data Expr num
  = Val num
  | Add (Expr num) (Expr num)
  | Sub (Expr num) (Expr num)
  | Mul (Expr num) (Expr num)
  | Div (Expr num) (Expr num)
  | Abs (Expr num)

%name Expr expr1, expr2, expr3, expr4

implementation Num num => Num (Expr num) where
  (+) = Add
  (*) = Mul
  fromInteger = Val . fromInteger

implementation Functor Expr where
  map f (Val x) = Val (f x)
  map f (Add expr1 expr2) = Add (map f expr1) (map f expr2)
  map f (Sub expr1 expr2) = Sub (map f expr1) (map f expr2)
  map f (Mul expr1 expr2) = Mul (map f expr1) (map f expr2)
  map f (Div expr1 expr2) = Div (map f expr1) (map f expr2)
  map f (Abs expr1) = Abs (map f expr1)

bracket : String -> String
bracket s = "(" ++ s ++ ")"

eval : (Neg num, Integral num, Abs num) => Expr num -> num
eval (Val num) = num
eval (Add expr1 expr2) = eval expr1 + eval expr2
eval (Sub expr1 expr2) = eval expr1 - eval expr2
eval (Mul expr1 expr2) = eval expr1 * eval expr2
eval (Div expr1 expr2) = eval expr1 `div` eval expr2
eval (Abs expr1) = abs (eval expr1)

implementation (Neg num, Integral num, Abs num, Eq num) => Eq (Expr num) where
  (==) expr1 expr2 = eval expr1 == eval expr2

implementation Show num => Show (Expr num) where
  show (Val n) = show n
  show (Add expr1 expr2) = bracket $ show expr1 ++ " + " ++ show expr2
  show (Sub expr1 expr2) = bracket $ show expr1 ++ " - " ++ show expr2
  show (Mul expr1 expr2) = bracket $ show expr1 ++ " * " ++ show expr2
  show (Div expr1 expr2) = bracket $ show expr1 ++ " / " ++ show expr2
  show (Abs expr1) = "abs" ++ bracket (show expr1)

implementation (Neg num, Integral num, Abs num) => Cast (Expr num) num where
  cast expr1 = eval expr1

e1 : Expr Integer
e1 = Add (Val 6) (Mul (Val 3) (Val 12))

e2 : Expr Integer
e2 = 6 + 3 * 12

implementation Cast (Maybe a) (List a) where
  cast Nothing = []
  cast (Just x) = [x]

totalLen1 : List String -> Nat
totalLen1 xs = foldr (\str, acc => length str + acc) 0 xs

totalLen2 : List String -> Nat
totalLen2 xs = foldl (\acc, str => length str + acc) 0 xs

haha : Stream String
haha = repeat "Muhahahahahahahahahahahahahahahahahahahahahaha"

example : List String
example = take 1000 haha

eg1 : Nat
eg1 = totalLen1 example

eg2 : Nat
eg2 = totalLen2 example

main : IO ()
main = do
  let x = take 100000 haha
  putStrLn "eg1"
  printLn $ totalLen1 x
  putStrLn "eg2"
  printLn $ totalLen2 x
