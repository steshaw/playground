import DataStore

%default total

testStore : DataStore (SString .+. SString .+. SInt)
testStore =
  addToStore ("Mercury", "Mariner 10", 1974) $
  addToStore ("Venus", "Venera", 1961) $
  addToStore ("Uranus", "Voyager 2", 1986) $
  addToStore ("Pluto", "New Horizons", 2015) $
  empty

listItems : DataStore schema -> List (SchemaType schema)
listItems store with (storeView store)
  listItems store | SNil = []
  listItems (addToStore value store1) | (SAdd rec) =
    value :: listItems store1 | rec

filterKeys :
  (test : SchemaType val_schema -> Bool) ->
  DataStore (SString .+. val_schema) ->
  List String
filterKeys test store with (storeView store)
  filterKeys test store | SNil = []
  filterKeys test (addToStore (key, value) store1) | (SAdd rec) =
    if test value
      then key :: filterKeys test store1 | rec
      else filterKeys test store1 | rec

--
-- Exercises
--

getValues :
  DataStore (SString .+. val_schema) ->
  List (SchemaType val_schema)
getValues store with (storeView store)
  getValues store | SNil = []
  getValues (addToStore (key, value) store1) | (SAdd rec) =
    value :: getValues store1 | rec

testStore2 : DataStore (SString .+. SInt)
testStore2 =
  addToStore ("First", 1) $
  addToStore ("Second", 2) $
  empty
