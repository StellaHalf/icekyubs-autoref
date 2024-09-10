module Out (encodeMoves) where

import qualified Data.ByteString.Lazy.Char8 as B
import Data.Char (toLower)
import Data.Foldable (Foldable (toList))
import Data.List (intersperse)
import GHC.Utils.Misc (unzipWith)
import Data.List.HT (replace)
import Control.Monad (join)
import Data.Either (isLeft)

encode :: Bool -> [(String, Either String [String])] -> String
encode t = join . ("{\n":) . (++["\n}"]) . intersperse ",\n" .
  unzipWith (\x y -> let s = (if t && isLeft y then "\"" else "") in "\t\"" ++ x ++ "\": " ++ s ++ replace "\n" "\n\t" (either id show y) ++ s)

attr :: [String]
attr = ["nom", "Level", "Frequency", "Accuracy", "Roll", "Type", "Target", "Desc", "aliases"]

encodeMoves :: (Functor v, Foldable v) => v [String] -> B.ByteString
encodeMoves = B.pack . encode False . toList . fmap (\x -> ((map toLower . filter (/=' ') . head) x, Left (encode True (zip attr (map Left x ++ [Right []])))))

