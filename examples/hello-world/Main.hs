module Main where

import           GHCJS.CommonJS (exportMain, exports)

main :: IO ()
main = exportMain
    [ "sayHello" `exports` putStrLn "Hello, I'm a Haskell"
    ]
