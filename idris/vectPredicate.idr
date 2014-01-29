
data Elem : a -> Vect n a -> Type where
  here  : {x:a}   -> {xs:Vect n a} -> Elem x (x :: xs)
  there : {x,y:a} -> {xs:Vect n a} -> Elem x xs -> Elem x (y :: xs)

v : Vect 4 Int
v = [3,4,5,6]

inVect : Elem 5 v
inVect = there (there here)
