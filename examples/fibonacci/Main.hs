module Main where

import           GHCJS.CommonJS (exportMain, exports)

fibs :: [Int]
fibs = 1 : 1 : zipWith (+) fibs (tail fibs)

main :: IO ()
main = exportMain
    [ "fibs" `exports` \n -> take n fibs
    -- ^ We can "exports" pure functions!
    , "fibsIO" `exports` \n -> do
            putStrLn ("HASKELL LAND - Calculating fibs of " ++ show n)
            return (take n fibs)
    -- ^ And IO still works as expected
    ]
