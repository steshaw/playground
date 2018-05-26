module Chapter5

import Data.Vect

%default total

partial
readVect : IO (len ** Vect len String)
readVect = do
  line <- getLine
  if line == ""
  then pure (0 ** [])
  else do
    (n ** lines) <- readVect
    pure (S n ** line :: lines)

partial
zipInputs : IO ()
zipInputs = do
  putStrLn "Enter first vector (blank line to end):"
  (len1 ** vec1) <- readVect
  putStrLn "Enter second vector (blank line to end):"
  (len2 ** vec2) <- readVect
  case exactLength len1 vec2 of
    Nothing => putStrLn "The vectors are not the same length"
    Just vec2' => do
      print $ zip vec1 vec2'
      putStrLn ""

partial
readToBlank : IO (List String)
readToBlank = loop []
  where
    partial
    loop : List String -> IO (List String)
    loop lines = do
      line <- getLine
      if line == ""
      then pure lines
      else do
        r <- loop lines
        pure (line :: r)

partial
readAndSave : IO ()
readAndSave = do
  lines <- readToBlank
  putStrLn "filename: "
  filename <- getLine
  x <- writeFile filename (unlines lines)
  case x of
    (Left fileError) => putStrLn $ "FileError: " ++ show fileError
    (Right r) => pure ()

--
-- Some functions we will need:
--
-- - openFile
-- - closeFile
-- - fEOF
-- - fGetLine
-- - writeFile
--

partial
linesFromFile : (file : File) -> IO (n : Nat ** Vect n String)
linesFromFile file = do
  eof <- fEOF file
  if eof
  then pure (_ ** [])
  else do
    Right line <- fGetLine file
      | Left fileError => do
        putStrLn ("FileError: " ++ show fileError)
        pure (_ ** [])
    (_ ** lines) <- linesFromFile file
    pure $ (_ ** line :: lines)

{-
Reads the contents of a file into a dependent pair containing a length and a
Vect of that length. If there are any errors, it should return an empty
vector.
-}
partial
readVectFile : (filename : String) -> IO (n ** Vect n String)
readVectFile filename = do
  Right file <- openFile filename Read
    | Left fileError => do
      putStrLn $ "FileError: " ++ show fileError
      pure (_ ** [])
  result <- linesFromFile file
  closeFile file
  pure result
