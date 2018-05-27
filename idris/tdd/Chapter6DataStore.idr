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
  SetSchema : (newSchema : Schema) -> Command schema
  List : Command schema
  Clear : Command schema
  Add : SchemaType schema -> Command schema
  Get : Integer -> Command schema
  Search : String -> Command schema
  Size : Command schema
  Quit : Command schema
  Empty : Command schema

parsePrefix :
  (schema : Schema) ->
  (input: String) ->
  Maybe (SchemaType schema, String)
parsePrefix SString input = getQuoted (unpack input)
  where
    getQuoted : List Char -> Maybe (String, String)
    getQuoted ('\"' :: xs) =
      case span (/= '"') xs of
        (quoted, '"' :: rest) => pure (pack quoted, ltrim (pack rest))
        _ => empty
    getQuoted _ = empty
parsePrefix SInt input =
  case span isDigit input of
    ("", rest) => empty
    (num, rest) => pure (cast num, ltrim rest)
parsePrefix (lschema .+. rschema) input =
  case parsePrefix lschema input of
    Nothing => empty
    Just (lval, remainingInput) =>
      case parsePrefix rschema remainingInput of
        Nothing => empty
        Just (rval, rest) => pure ((lval, rval), rest)

parseBySchema : (schema : Schema) -> (input : String) -> Maybe (SchemaType schema)
parseBySchema schema input =
  case parsePrefix schema input of
    Nothing => empty
    Just (val, "") => pure val
    Just _ => empty

parseSchema : List String -> Maybe Schema
parseSchema ("String" :: xs) =
  case xs of
    [] => pure SString
    _ => do schema <- parseSchema xs
            pure (SString .+. schema)
parseSchema ("Int" :: xs) =
  case xs of
    [] => pure SInt
    _ => do schema <- parseSchema xs
            pure (SInt .+. schema)
parseSchema _ = Nothing

parseInteger : String -> Maybe Integer
parseInteger input =
  case all isDigit (unpack input) of
    True => pure $ cast input
    False => empty

parseCommandHelper :
  (schema : Schema) ->
  (cmd : String) ->
  (args : String) ->
  Maybe (Command schema)
parseCommandHelper schema "schema" args =
  SetSchema <$> parseSchema (words args)
parseCommandHelper schema "list" "" = pure List
parseCommandHelper schema "clear" "" = pure Clear
parseCommandHelper schema "add" str =
  Add <$> parseBySchema schema str
parseCommandHelper schema "get" input =
  Get <$> parseInteger input
parseCommandHelper schema "search" str = pure $ Search str
parseCommandHelper schema "size" "" = pure Size
parseCommandHelper schema "quit" "" = pure Quit
parseCommandHelper schema "exit" "" = pure Quit -- alias for "quit"
parseCommandHelper schema "" "" = pure Empty
parseCommandHelper _ _ _ = empty

parseCommand : (schema : Schema) -> (input : String) -> Maybe (Command schema)
parseCommand schema input =
  case span (/= ' ') input of
    (cmd, args) => parseCommandHelper schema cmd (ltrim args)

tryIndex : Integer -> Vect n a -> Maybe a
tryIndex x xs {n} = do
  x <- integerToFin x n
  pure $ index x xs

indices : Vect n a -> Vect n Integer
indices xs = loop 0 xs
  where
    loop : Integer -> (xs : Vect n a) -> Vect n Integer
    loop i [] = []
    loop i (x :: xs) = i :: loop (i + 1) xs

zipWithIndex : Vect n a -> Vect n (Integer, a)
zipWithIndex xs = zip (indices xs) xs

display : SchemaType schema -> String
display {schema = SString} string = show string
display {schema = SInt} int = show int
display {schema = (lschema .+. rschema)} (a, b) =
  display a ++ ", " ++ display b

getEntry : (store : DataStore) -> (i : Integer) -> Maybe (String, DataStore)
getEntry store i =
  let
    item = tryIndex i (items store)
    message = maybe "Index out of range\n" (\item =>
      "Item: " ++ (display item) ++ "\n") item
  in Just (message, store)

setSchema : (store : DataStore) -> Schema -> Maybe DataStore
setSchema store schema =
  case size store of
    Z => Just (MkDataStore schema _ [])
    _ => Nothing

processCommand :
  (store : DataStore) ->
  (command : Command (schema store)) ->
  Maybe (String, DataStore)
processCommand store (SetSchema schema) =
  case setSchema store schema of
    Nothing => pure ("Can't update schema when you have existing items", store)
    Just store => pure ("Updated schema", store)
processCommand store List =
  let
    indexedItems = zipWithIndex (items store)
    resultsPerLine = concat $ intersperse "\n" $
      map (\(i, item) => "  " ++ show i ++ ": " ++ display item) indexedItems
  in pure ("Items:\n" ++ resultsPerLine ++ "\n", store)
processCommand store Clear =
  pure ("Cleared", MkDataStore (schema store) _ [])
processCommand store (Add item) =
  pure ("ID " ++ show (size store) ++ "\n", addToStore store item)
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
  pure ("Size: " ++ show (size store) ++ "\n", store)
processCommand _ Quit = empty
processCommand store Empty = pure ("", store)

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
