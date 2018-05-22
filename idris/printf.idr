--
-- Port of printf from "Cayenne - a language with dependent types"
-- http://fsl.cs.illinois.edu/images/5/5e/Cayenne.pdf
-- https://github.com/csgordon/cayenne/blob/master/test/printf.cy
--

-- Turns out that a straightforward port of Cayenne's prints causes
-- a type error in Idris.

%default total

PrintfType : List Char -> Type
PrintfType Nil = String
PrintfType ('%' :: 'd' :: cs) = Int    -> PrintfType cs
PrintfType ('%' :: 's' :: cs) = String -> PrintfType cs
PrintfType ('%' :: _   :: cs) =           PrintfType cs
PrintfType (_ :: cs)          =           PrintfType cs

{-
tryA : PrintfType ('%' :: 'c' :: cs) = PrintfType cs
tryA = Refl

tryB : PrintfType cs = PrintfType ('%' :: 'x' :: cs)
tryB = Refl
-}

printf' : (fmt : List Char) -> String -> PrintfType fmt
printf' [] out                 = out
printf' ('%' :: 'd' :: cs) out = \i => printf' cs (out ++ show i)
printf' ('%' :: 's' :: cs) out = \s => printf' cs (out ++ s)
printf' ('%' :: c :: cs) out =         printf' cs (out ++ singleton c)
printf' (c :: cs)        out =         printf' cs (out ++ singleton c)

printf : (fmt : String) -> PrintfType (unpack fmt)
printf fmt = printf' (unpack fmt) ""
