import System(getArgs)

consume s ('[':xs) = consume ('[':s) xs
consume ('[':s) (']':xs) = consume s xs
consume s ('(':xs) = consume ('(':s) xs
consume ('(':s) (')':xs) = consume s xs
consume s [] = null s
consume _ _ = False

main = getArgs >>= print . show . map (consume [])
