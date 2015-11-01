import Data.Vect

{-
word_lengths : Vect len String -> Vect len Nat
word_lengths [] = []
word_lengths (word :: words) = length word :: word_lengths words
-}

{-
total
word_lengths : Vect len String -> Vect len Nat
word_lengths [] = []
word_lengths (word :: words) = length word :: word_lengths words
-}

total
word_lengths : Vect len String -> Vect len Nat
word_lengths [] = []
word_lengths (word :: words) = length word :: word_lengths words
