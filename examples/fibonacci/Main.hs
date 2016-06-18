module Main where

import qualified GHCJS.CommonJS as CommonJS

fibs :: [Int]
fibs = 1 : 1 : zipWith (+) fibs (tail fibs)

main :: IO ()
main = CommonJS.exportMain
    [ CommonJS.pack ("fibs", \n -> take n fibs)
    -- ^ We can "CommonJS.pack" pure functions!
    , CommonJS.pack
        ("fibsIO", \n -> do
                putStrLn ("HASKELL LAND - Calculating fibs of " ++ show n)
                return (take n fibs)
        )
    -- ^ And IO still works as expected
    ]
