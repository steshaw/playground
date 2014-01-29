
vapp : Vect n a -> Vect n a -> Vect (n + n) a
vapp Nil ys = ys
vapp (x :: xs) ys = x :: vapp xs xs -- XXX Still broken
