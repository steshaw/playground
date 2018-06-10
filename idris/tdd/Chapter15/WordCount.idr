|||
||| ### 15.2.7 Example 2: A word-counting process
|||
module Main

import ProcessLib

record WCData where
  constructor MkWCData
  wordCount : Nat
  lineCount : Nat

Show WCData where
  show (MkWCData wordCount lineCount) =
    concat (map pack $ intersperse (unpack " ") (map unpack [
      "MkWCData",
      "wordCount = " ++ show wordCount,
      "lineCount = " ++ show lineCount
    ]))

doCount : (content : String) -> WCData
doCount content =
  let
    lcount = length (lines content)
    wcount = length (words content)
  in MkWCData wcount lcount

data WC
  = CountFile String
  | GetData String

WCType : WC -> Type
WCType (CountFile x) = ()
WCType (GetData x) = Maybe WCData

countFile :
  (files : List (String, WCData)) ->
  (fileName : String) ->
  Process WCType (List (String, WCData)) Sent Sent
countFile files fileName = do
  Right content <- Action (readFile fileName)
    | Left error => do
        Action (putStrLn ("Something went wrong reading " ++ fileName ++ ": " ++
                show error))
        Pure files
  let wcData = doCount content
  Action $ do
    putStrLn $ "Counting complete for " ++ fileName
    printLn wcData
  Pure $ (fileName, wcData) :: files

wcService : (loaded : List (String, WCData)) -> Service WCType ()
wcService loaded = do
  msg <- Respond $ \msg => do
    case msg of
      CountFile fileName => Pure () -- <-- XXX: do we continue here?
      GetData fileName => Pure (lookup fileName loaded)
  newLoaded <- case msg of
    Just (CountFile fileName) => countFile loaded fileName
    _ => Pure loaded
  Loop (wcService newLoaded)

procMain : Client ()
procMain = do
  let fileName = "WordCount.idr"
  Just wc <- Spawn (wcService [])
    | Nothing => Action (putStrLn "Spawn word count service failed")
  Action (putStrLn "Counting test.txt")
  Request wc (CountFile fileName)
  Action (putStrLn "Processing")
  Just wcData <- Request wc (GetData fileName)
    | Nothing => Action (putStrLn "Probably a file error")
  Action (putStrLn ("Words: " ++ show (wordCount wcData)))
  Action (putStrLn ("Lines: " ++ show (lineCount wcData)))

main : IO ()
main = runProcess procMain
