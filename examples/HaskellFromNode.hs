import Control.Lens
import Control.Concurrent
import Control.Concurrent.Async
import System.Random

main = do
    putStrLn "Hello I'm in Haskell Land"
    putStrLn "This is what concurrency looks like:"
    as <- mapConcurrently
      getVerbose
      [ "https://amazon.com", "https://reddit.com", "https://haskell.org" ]
    putStrLn "All good:"
    print as

get url = do
    r <- randomRIO (0, 10)
    threadDelay (1000 * 1000 * r)
    return "RESPONSE HERE"

getVerbose url = do
    putStrLn $ "Pretending to fetch " ++ url ++ "..."
    res <- get url
    putStrLn $ "Fetched " ++ url ++ "!"
    return $ res
