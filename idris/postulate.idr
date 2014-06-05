%default total
 
class Semigroupy a where
  op: a -> a -> a
  semigroupOpIsAssociative : (x, y, z : a) -> op x (op y z) = op (op x y) z
 
instance Semigroupy Int where
  op = (+)
  semigroupOpIsAssociative x y z = believe_me "sure, yeah, whatever"
 
{-
  A problem with that is that now the value of the proof is that string.
  Which could break anything expecting the more usual value, "refl".
  Using "postulate" instead doesn't have that problem, because it doesn't reduce (no value).
-}
  
instance Semigroupy Integer where
  op = (+)
  semigroupOpIsAssociative x y z = integerAssociative
    where postulate integerAssociative : x + (y + z) = (x + y) + z
