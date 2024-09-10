module In (getMoves, getBasic) where
import qualified Data.Vector as V (map, indexed, filter, (!), Vector, maximum, tail)
import qualified Data.ByteString.Lazy.Char8 as B (ByteString, unpack, length)
import Data.Char (isNumber)
import Control.Monad.Fix (fix)
import Control.Monad (ap)
import Control.Arrow (Arrow(second))
import Data.List.HT (replace)

buildMove :: (String -> String) -> V.Vector String -> [String]
buildMove l v = map (replace "\"" "\\\"" . filter (/='\n')) [v V.!0, l (v V.!1), v V.!2, v V.!3, v V.!4, v V.! 5 ++ "/" ++ v V.! 6,
  concat [v V.!7, "/" ,v V.!8, "/", v V.!9], v V.!10]

getMoves :: V.Vector (V.Vector B.ByteString) -> V.Vector [String]
getMoves csv = (V.map (\l -> buildMove (((head . words . B.unpack) (csv V.! (V.maximum . V.filter (<= fst l))
   ((V.map fst . V.filter (all ((0==) . B.length) . V.tail . snd) . V.indexed) csv) V.!0) ++ " ")++) (snd l))
  . V.map (second (V.map B.unpack)) . V.filter (ap ((&&) . all isNumber . B.unpack) ((> 0) . B.length) . fix . const . (V.! 1) . snd)  . V.indexed) csv

getBasic :: V.Vector (V.Vector B.ByteString) -> V.Vector [String]
getBasic = V.map (buildMove (const  "Basic")) . V.map (V.map B.unpack) . V.filter (("B"==) . B.unpack . (V.! 1))
