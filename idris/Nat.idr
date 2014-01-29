--
-- Needs `idris --noprelude`
--

module Nat

data Nat
  = Z
  | S Nat

infixl 8 +

(+) : Nat -> Nat -> Nat
Z     + y = y
(S k) + y = S (k + y)
