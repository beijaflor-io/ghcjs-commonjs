module Main where

import qualified GHCJS.CommonJS as CommonJS

willThrowWithPairNumbers :: Int -> IO ()
willThrowWithPairNumbers n =
    if even n
       then error "What are you doing!?"
       else putStrLn "[haskell] All good"

main :: IO ()
main = CommonJS.exportMain
    [ CommonJS.pack ("willThrowWithPairNumbers", willThrowWithPairNumbers)
    ]
