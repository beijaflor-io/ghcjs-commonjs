module Main where

import qualified GHCJS.CommonJS as CommonJS

main :: IO ()
main = CommonJS.exportMain
    [ CommonJS.pack ("sayHello", putStrLn "Hello, I'm a Haskell")
    ]
