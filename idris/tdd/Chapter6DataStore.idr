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

record DataStore where
  constructor MkDataStore
  schema : Schema
  size : Nat
  items : Vect size (SchemaType schema)

%name DataStore store, store1, store2, store3

addToStore : (store: DataStore) -> SchemaType (schema store) -> DataStore
addToStore (MkDataStore schema size items) x =
  MkDataStore schema _ (items ++ [x])

data Command : Schema -> Type where
  Add : SchemaType schema -> Command schema
  Get : Integer -> Command schema
  Search : String -> Command schema
  Size : Command schema
  Quit : Command schema
  Empty : Command schema

parseCommandHelper : (schema : Schema) -> (cmd : String) -> (args : String) -> Maybe (Command schema)
parseCommandHelper schema "add" str = Just (Add (?parseBySchema str))
parseCommandHelper schema "get" i =
  if all isDigit (unpack i)
  then Just (Get (cast i))
  else Nothing
parseCommandHelper schema "search" str = Just (Search str)
parseCommandHelper schema "size" "" = Just Size
parseCommandHelper schema "quit" "" = Just Quit
parseCommandHelper schema "" "" = Just Empty
parseCommandHelper _ _ _ = Nothing

parseCommand : (schema : Schema) -> (input : String) -> Maybe (Command schema)
parseCommand schema input =
  case span (/= ' ') input of
    (cmd, args) => parseCommandHelper schema cmd (ltrim args)

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

getEntry : (store : DataStore) -> (i : Integer) -> Maybe (String, DataStore)
getEntry store i =
  let
    item = tryIndex i (items store)
    message = maybe "Index out of range\n" (\item =>
      "Item: " ++ ?showItem item ++ "\n") item
  in Just (message, store)

processCommand :
  (store : DataStore) ->
  (command : Command (schema store)) ->
  Maybe (String, DataStore)
processCommand store (Add item) =
  Just ("ID " ++ show (size store) ++ "\n", addToStore store item)
processCommand store (Get i) = getEntry store i
processCommand store (Search s) =
  ?rethinkSearch
{-
--
-- Probably just search through all the strings.
-- Alternatively turn the integers to strings too
-- and do "full text" search.
--
  let indexedItems = zipWithIndex (items store)
  in case filter (isInfixOf s . snd) indexedItems of
         (len ** results) =>
           let resultsPerLine = concat $ intersperse "\n" $
                 map (\(i, item) => "  " ++ show i ++ ": " ++ item) results
           in Just ("Results:\n" ++ resultsPerLine ++ "\n", store)
-}
processCommand store Size =
  Just ("Size: " ++ show (size store) ++ "\n", store)
processCommand _ Quit = Nothing
processCommand store Empty = Just ("", store)

processInput : DataStore -> String -> Maybe (String, DataStore)
processInput store input =
  case parseCommand (schema store) input of
    Nothing => Just ("You've entered an unknown command\n", store)
    (Just command) => processCommand store command

partial
main : IO ()
main = replWith initialStore "\nCommand: " processInput
  where
    schema : Schema
    schema = SInt .+. SString
    initialStore = MkDataStore schema _
      [ (0, "zero")
      , (1, "one")
      , (2, "two")
      ]
