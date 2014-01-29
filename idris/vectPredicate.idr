
using (x:a, y:a, xs:Vect n a)
  data Elem : a -> Vect n a -> Type where
    here  : Elem x (x :: xs)
    there : Elem x xs -> Elem x (y :: xs)

v : Vect 4 Int
v = [3,4,5,6]

inVect : Elem 5 v
inVect = there (there here)
