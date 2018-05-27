--
-- DataStore with schemas.
--
module Main

import Data.Vect

%default total

infixr 5 .+.

data Schema
  = SString
  | SInt
  | (.+.) Schema Schema

%name Schema schema, schema1, schema2, schema3

SchemaType : Schema -> Type
SchemaType SString = String
SchemaType SInt = Int
SchemaType (l .+. r) = (SchemaType l, SchemaType r)

data DataStore : Type where
  MkData :
    (schema : Schema) ->
    (size : Nat) ->
    (items : Vect size (SchemaType schema)) ->
    DataStore

%name DataStore store, store1, store2, store3

size : DataStore -> Nat
size (MkData _ size _) = size

schema : DataStore -> Schema
schema (MkData schema _ _) = schema

items : (store: DataStore) -> Vect (size store) (SchemaType (schema store))
items (MkData _ _ items) = items
--items (MkData size items) = items

{-
addToStore : DataStore -> String -> DataStore
addToStore (MkData size items) x = MkData _ (items ++ [x])

sumInputs : Integer -> String -> Maybe (String, Integer)
sumInputs tot input =
  let val = cast input in
  if val <= 0 then Nothing -- quit
  else
    let total2 = tot + val
    in Just ("Subtotal: " ++ show total2 ++ "\n", total2)

data Command
  = Add String
  | Get Integer
  | Search String
  | Size
  | Quit
  | Empty

parseCommandHelper : (cmd : String) -> (args : String) -> Maybe Command
parseCommandHelper "add" str = Just (Add str)
parseCommandHelper "get" i =
  if all isDigit (unpack i)
  then Just (Get (cast i))
  else Nothing
parseCommandHelper "search" str = Just (Search str)
parseCommandHelper "size" "" = Just Size
parseCommandHelper "quit" "" = Just Quit
parseCommandHelper "" "" = Just Empty
parseCommandHelper _ _ = Nothing

parseCommand : (input : String) -> Maybe Command
parseCommand input =
  case span (/= ' ') input of
    (cmd, args) => parseCommandHelper cmd (ltrim args)

tryIndex : Integer -> Vect n a -> Maybe a
tryIndex x xs {n} =
  case integerToFin x n of
    Nothing => Nothing
    Just x => Just $ index x xs

indices : Vect n a -> Vect n Integer
indices xs = loop 0 xs
  where
    loop : Integer -> (xs : Vect n a) -> Vect n Integer
    loop i [] = []
    loop i (x :: xs) = i :: loop (i + 1) xs

zipWithIndex : Vect n a -> Vect n (Integer, a)
zipWithIndex xs = zip (indices xs) xs

processCommand :
  (command : Command) ->
  (store : DataStore) ->
  Maybe (String, DataStore)
processCommand (Add s) store =
  Just ("ID " ++ show (size store) ++ "\n", addToStore store s)
processCommand (Get i) store =
  let
    item = tryIndex i (items store)
    message = maybe "Index out of range\n" (\item =>
      "Item: " ++ item ++ "\n") item
  in Just (message, store)
processCommand (Search s) store =
  let indexedItems = zipWithIndex (items store)
  in case filter (isInfixOf s . snd) indexedItems of
         (len ** results) =>
           let resultsPerLine = concat $ intersperse "\n" $
                 map (\(i, item) => "  " ++ show i ++ ": " ++ item) results
           in Just ("Results:\n" ++ resultsPerLine ++ "\n", store)
processCommand Size store =
  Just ("Size: " ++ show (size store) ++ "\n", store)
processCommand Quit _ =
  Nothing
processCommand Empty store =
  Just ("", store)

processInput : DataStore -> String -> Maybe (String, DataStore)
processInput store input =
  case parseCommand input of
    Nothing => Just ("You've entered an unknown command\n", store)
    (Just command) => processCommand command store

partial
main : IO ()
main = replWith emptyDataStore "\nCommand: " processInput
  where
    emptyDataStore = MkData 0 []

-}
