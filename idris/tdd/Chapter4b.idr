module Chapter4b

import Data.Vect

tryIndex : Integer -> Vect n a -> Maybe a
tryIndex x xs {n} = case integerToFin x n of
                      Nothing => Nothing
                      (Just x) => Just $ Vect.index x xs
