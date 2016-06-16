-- module EventEmitter where
{-# LANGUAGE OverloadedStrings #-}
import           Control.Concurrent
import           Control.Monad
import           Data.JSString
import           Data.String
import           GHCJS.Foreign
import           GHCJS.Foreign.Callback
import           GHCJS.Types
import           JavaScript.Array
import           JavaScript.Object

newtype EventEmitter = EventEmitter JSVal

newEmitter :: IO EventEmitter
newEmitter = EventEmitter <$> js_newEmitter

emit1 :: EventEmitter -> String -> JSVal -> IO JSVal
emit1 (EventEmitter emitter) name arg =
    js_emit1 emitter (fromString name) arg

on1 :: EventEmitter -> String -> IO () -> IO ()
on1 (EventEmitter emitter) name action = do
    let jsName = fromString name
    callback <- asyncCallback action
    js_on1 emitter jsName callback

getRegisterEmitter :: IO EventEmitter
getRegisterEmitter = EventEmitter <$> js_registerEmitter

foreign import javascript unsafe "$r = global.emitter"
    js_registerEmitter :: IO JSVal

foreign import javascript unsafe "$r = $1.emit($2, $3)"
    js_emit1 :: JSVal -> JSString -> JSVal -> IO JSVal

foreign import javascript unsafe "$1.on($2, $3)"
    js_on1 :: JSVal -> JSString -> Callback (IO ()) -> IO ()

foreign import javascript unsafe "$r = new EventEmitter()"
    js_newEmitter :: IO JSVal

exports :: String -> JSVal -> IO ()
exports name val = js_exports (fromString name) val

foreign import javascript unsafe "exports[$1] = $2"
    js_exports :: JSString -> JSVal -> IO ()

main = do
    putStrLn "[haskell] Starting Haskell"
    putStrLn "[haskell] Getting reference to ghcjs-register emitter"
    emitter <- getRegisterEmitter
    putStrLn "[haskell] Emitting 'something' event!"
    emit1 emitter "something" (jsval ("hello world" :: JSString))

    forkIO $ forever $ do
        tid <- myThreadId
        putStrLn $ "[haskell - " ++ show tid ++ "] Emitting 'something' event!"
        emit1 emitter "something" (jsval ("hello world" :: JSString))
        threadDelay (1000 * 1000)

    tid <- myThreadId
    putStrLn $ "[haskell - " ++ show tid ++ "] Listening for 'foo'"
    on1 emitter "foo" $ do
        tid <- myThreadId
        putStrLn $ "[haskell - " ++ show tid ++ "] Got 'foo' event!"

    putStrLn $ "[haskell - " ++ show tid ++ "] This thread is still free to run"
