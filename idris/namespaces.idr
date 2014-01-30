module namespaces

namespace int
  test : Int -> Int
  test = (* 2)

namespace string
  test : String -> String
  test = pack . map toUpper . unpack
