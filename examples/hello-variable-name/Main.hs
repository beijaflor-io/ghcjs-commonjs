module Main where

import qualified GHCJS.CommonJS as CommonJS

main :: IO ()
main = CommonJS.exportMain
    [ CommonJS.pack ("sayHello", \name -> putStrLn ("Hello " ++ name))
    ]
