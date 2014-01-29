
intVec : Vect 5 Int
intVec = [1,2,3,4,5]

double : Int -> Int
double x = x * 2

vec : (n ** Vect n Int)
vec = (_ ** [3, 4])

listLookup : Nat -> List a -> Maybe a
listLookup _ Nil           = Nothing
listLookup Z     (x :: xs) = Just x
listLookup (S k) (x :: xs) = listLookup k xs

lookupDefault : Nat -> List a -> a -> a
lookupDefault index xs default =
  case listLookup index xs of
    Nothing => default
    Just x  => x

