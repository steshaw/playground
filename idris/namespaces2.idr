module namespaces

-- appears to be fully qualified as `int.test` rather than `namespaces.int.test`.
int.test : Int -> Int
int.test = (* 2)

-- appears to be fully qualified as `string.test` rather than `namespaces.string.test`.
string.test : String -> String
string.test = pack . map toUpper . unpack

square : Int -> Int
square n = (\fred.wilma => fred.wilma * fred.wilma) n
