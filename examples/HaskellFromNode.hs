{-# LANGUAGE OverloadedStrings #-}
import Control.Lens
import Control.Concurrent
import Control.Concurrent.Async
import System.Random
import           JavaScript.Object
import           GHCJS.Foreign
import           GHCJS.Types

main = do
    putStrLn "Hello I'm in Haskell Land"
    putStrLn "This is what concurrency looks like:"
    as <- mapConcurrently
      getVerbose
      [ "https://amazon.com", "https://reddit.com", "https://haskell.org" ]
    putStrLn "All good:"
    print as

    emitter <- js_emitter
    js_emit emitter "hello"

foreign import javascript unsafe "global.emitter"
    js_emitter :: IO Object

foreign import javascript unsafe "$1.emit($2)"
    js_emit :: Object -> JSString -> IO ()

get url = do
    r <- randomRIO (0, 10)
    threadDelay (1000 * 1000 * r)
    return "RESPONSE HERE"

getVerbose url = do
    putStrLn $ "Pretending to fetch " ++ url ++ "..."
    res <- get url
    putStrLn $ "Fetched " ++ url ++ "!"
    return $ res
