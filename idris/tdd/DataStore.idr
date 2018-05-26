module Main

import Data.Vect

%default total

data DataStore : Type where
  MkData : (size : Nat) ->
    (items : Vect size String) ->
    DataStore

%name DataStore store, store1, store2, store3

size : DataStore -> Nat
size (MkData size items) = size

items : (store: DataStore) -> Vect (size store) String
items (MkData size items) = items

addToStore : DataStore -> String -> DataStore
addToStore (MkData size items) x = MkData _ (items ++ [x])

sumInputs : Integer -> String -> Maybe (String, Integer)
sumInputs tot input =
  let val = cast input in
  if val <= 0 then Nothing -- quit
  else
    let total2 = tot + val
    in Just ("Subtotal: " ++ show total2 ++ "\n", total2)

partial
main : IO ()
main = replWith 0 "Value: " sumInputs
