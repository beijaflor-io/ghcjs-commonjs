import           Control.Concurrent
import           GHCJS.CommonJS     (exportMain, exports)

helloWorld = putStrLn "[haskell] Hello World"

launchTheMissiles :: IO Int
launchTheMissiles = do
    threadDelay (1000 * 1000 * 5)
    putStrLn "[haskell] OMG what did I do?!"
    return 10

main =
    exportMain
        [ "helloWorld" `exports` helloWorld
        , "launchTheMissiles" `exports` launchTheMissiles
        ]
