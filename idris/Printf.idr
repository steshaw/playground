--
-- Port of printf from "Cayenne - a language with dependent types"
--
-- http://fsl.cs.illinois.edu/images/5/5e/Cayenne.pdf
-- https://github.com/csgordon/cayenne/blob/master/test/printf.cy
--

--
-- Turns out that a straightforward port of Cayenne's prints causes
-- a type error in Idris. Thanks to tip from Guillaume Allais, I got
-- a working version using a view. I'm curious what differences
-- between Cayenne and Idris mean that the straightforward port
-- does not work as expected.
--

module Printf

%default total

data PrintfView : List Char -> Type where
  PInt : PrintfView ('%' :: 'd' :: cs)
  PString : PrintfView ('%' :: 's' :: cs)
  PEscaped : PrintfView ('%' :: c :: cs)
  PDefault : PrintfView (c :: cs)
  PEnd : PrintfView []

printfView : (cs : List Char) -> PrintfView cs
printfView [] = PEnd
printfView ('%' :: 'd' :: cs) = PInt
printfView ('%' :: 's' :: cs) = PString
printfView ('%' :: c :: cs) = PEscaped
printfView (c :: cs) = PDefault

PrintfType : List Char -> Type
PrintfType cs with (printfView cs)
  PrintfType ('%' :: ('d' :: cs)) | PInt     = Int     -> PrintfType cs
  PrintfType ('%' :: ('s' :: cs)) | PString  = String  -> PrintfType cs
  PrintfType ('%' :: (c :: cs))   | PEscaped =            PrintfType cs
  PrintfType (c :: cs)            | PDefault =            PrintfType cs
  PrintfType []                   | PEnd     = String

printf' : (fmt : List Char) -> String -> PrintfType fmt
printf' fmt out with (printfView fmt)
  printf' ('%' :: ('d' :: cs)) out | PInt     = \i => printf' cs (out ++ show i)
  printf' ('%' :: ('s' :: cs)) out | PString  = \s => printf' cs (out ++ s)
  printf' ('%' :: (c :: cs)) out   | PEscaped =       printf' cs (out ++ singleton c)
  printf' (c :: cs) out            | PDefault =       printf' cs (out ++ singleton c)
  printf' [] out                   | PEnd     = out

printf : (fmt : String) -> PrintfType (unpack fmt)
printf fmt = printf' (unpack fmt) ""

eg1 : printf "Hello %s" "Fred" = "Hello Fred"
eg1 = Refl

eg2 : printf "Hello %s (%d)" "Fred" 45 = "Hello Fred (45)"
eg2 = Refl
