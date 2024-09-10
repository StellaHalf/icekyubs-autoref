module Main (main) where

import qualified Data.ByteString.Lazy.Char8 as B
import Data.Csv (HasHeader (HasHeader), decode)
import qualified Data.Vector as V
import GHC.Utils.Misc (split)
import In (getBasic, getMoves)
import Out (encodeMoves)
import System.Exit (exitFailure)
import System.Environment (getArgs)

main :: IO ()
main = do
  args <- getArgs
  if length args < 2 then putStrLn "Not enough arguments." >> exitFailure else do
    let basicFile = head args
    basicContents <- B.readFile basicFile
    let otherFilesList = args !! 1
    otherContents <- (mapM B.readFile . split ',') otherFilesList
    either
      (\s -> putStrLn ("Parse Error: " ++ s))
      (\basicMoves -> do
          otherMoves <- mapM (either (\s -> putStrLn ("Parse Error: " ++ s) >> exitFailure) return) (map (decode HasHeader) otherContents :: [Either String (V.Vector (V.Vector B.ByteString))])
          let outFile = if length args > 2 then args !! 2 else "data/moves.json"
          B.writeFile outFile (encodeMoves (V.concat [getBasic basicMoves, (V.concat . fmap getMoves) otherMoves]))
      )
      (decode HasHeader basicContents :: Either String (V.Vector (V.Vector B.ByteString)))
