word_lengths : List String -> List Nat
word_lengths [] = []
word_lengths (word :: words) = length word :: word_lengths words
