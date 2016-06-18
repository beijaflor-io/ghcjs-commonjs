import           Control.Concurrent
import qualified GHCJS.CommonJS as CommonJS

helloWorld = putStrLn "[haskell] Hello World"

launchTheMissiles :: IO Int
launchTheMissiles = do
    threadDelay (1000 * 1000 * 5)
    putStrLn "[haskell] OMG what did I do?!"
    return 10

main =
    CommonJS.exportMain
        [ CommonJS.pack ("helloWorld", helloWorld)
        , CommonJS.pack ("launchTheMissiles", launchTheMissiles)
        ]
