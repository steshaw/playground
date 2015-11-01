
isEven : Nat -> Bool
isEven Z = True
isEven (S k) = not (isEven k)
