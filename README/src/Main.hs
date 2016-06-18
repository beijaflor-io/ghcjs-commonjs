import Control.Concurrent (threadDelay)
import qualified GHCJS.CommonJS as CommonJS (exportMain, pack)
someFunction = do
    putStrLn "Waiting for a second"
    threadDelay (1000 * 1000)
    putStrLn "Done!"
main =
    CommonJS.exportMain [ CommonJS.pack ("someFunction", someFunction)
                        ]
