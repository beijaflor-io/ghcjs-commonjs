module Main where

import           GHCJS.CommonJS (exportMain, exports)

main :: IO ()
main = exportMain
    [ "sayHello" `exports` \name -> putStrLn ("Hello " ++ name)
    ]
