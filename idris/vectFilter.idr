
v : Vect 6 Integer
v = [1,2,3,4,5,6]

r : (n ** Vect n Integer)
r = filter (> 3) v

total
my.filter : (a -> Bool) -> Vect n a -> (m ** Vect m a)
my.filter p Nil = (_ ** [])
my.filter p (x :: xs) with (my.filter p xs)
  | (_ ** xs') = if (p x) then (_ ** x :: xs') else (_ ** xs')

