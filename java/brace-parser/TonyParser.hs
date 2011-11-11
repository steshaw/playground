import Prelude hiding (foldr, any)
import Control.Monad (mplus, guard)
import Data.Foldable (foldr, any)
import System (getArgs)
 
tokens = [('(', ')'), ('[', ']')]
 
parse x = any null (foldr (\c f -> (\s -> (const (c:s)) `fmap`
            flip lookup ((uncurry (flip (,))) `fmap` tokens)  c `mplus`
              (flip lookup tokens c >>= (\v ->
                do h:t <- return s
                   guard (v == h)
                   return t))) =<< f) (return []) x)
 
main = getArgs >>= print . (parse `fmap`)
