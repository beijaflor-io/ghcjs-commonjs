import           Control.Concurrent
import           GHCJS.Marshal.Pure
import           GHCJS.Require

helloWorld = putStrLn "Hello World"

launchTheMissiles = do
    threadDelay (1000 * 1000 * 5)
    putStrLn "OMG what did I do?!"
    return $ Just $ pToJSVal (10 :: Double)

main = do
    export0 "helloWorld" helloWorld
    export "launchTheMissiles" launchTheMissiles
    defaultMain
