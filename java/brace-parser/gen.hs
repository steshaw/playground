
roundBrace 0 = ""
roundBrace n = "(" ++ squareBrace (n - 1) ++ ")"

squareBrace 0 = ""
squareBrace n = "[" ++ roundBrace (n - 1) ++ "]"

main = putStrLn $ squareBrace 1 ++ roundBrace 30000 ++ roundBrace 50 ++ roundBrace 10 ++ squareBrace 5
