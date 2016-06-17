module GHCJS.Require
  where

import           Control.Concurrent
import           Control.Monad
import           Data.JSString
import           Data.String
import           GHCJS.Foreign
import           GHCJS.Foreign.Callback
import           GHCJS.Marshal
import           GHCJS.Types
import           JavaScript.Array
import           JavaScript.Object
import           JavaScript.EventEmitter
import Data.Coerce

import System.IO.Unsafe

defaultMain = do
    emitter <- getRequireEmitter

    on2 emitter "ghcjs-require:runexport" $ \name cb -> do
        Just str <- fromJSVal name :: IO (Maybe JSString)
        maction <- getExport (unpack str)
        mvl <- case maction of
            Just action -> action
            Nothing -> return Nothing
        case mvl of
            Just vl -> call2 cb nullRef vl
            Nothing -> call1 cb nullRef

    emit0 emitter "ghcjs-require:loaded"

foreign import javascript unsafe "$1()"
   call0 :: JSVal -> IO ()

foreign import javascript unsafe "$1($2)"
   call1 :: JSVal -> JSVal -> IO ()

foreign import javascript unsafe "$1($2, $3)"
   call2 :: JSVal -> JSVal -> JSVal -> IO ()

exports = unsafePerformIO (newMVar [])
{-# NOINLINE exports #-}

getExport :: String -> IO (Maybe (IO (Maybe JSVal)))
getExport name = lookup name <$> readMVar exports

registerExport :: String -> IO (Maybe JSVal) -> IO ()
registerExport name action = modifyMVar_ exports $ \e ->
    return $ (name, action):e

require :: String -> IO JSVal
require = js_require . fromString

export :: String -> IO (Maybe JSVal) -> IO ()
export name action = do
    let name' = fromString name
    registerExport name $ action
    callback <- asyncCallback (void action)
    js_export name' callback

export0 name action = export name $ do
    action
    return Nothing

getRequireEmitter :: IO EventEmitter
getRequireEmitter = emitter <$> js_getRequireEmitter

foreign import javascript unsafe "$r = require($1)"
    js_require :: JSString -> IO JSVal

-- foreign import javascript unsafe "global.startAction"
--     js_startAction :: IO JSString

-- foreign import javascript unsafe "global.finishAction"
--     js_finishAction0 :: JSString -> IO ()

foreign import javascript unsafe "global.exports[$1] = $2"
    js_export :: JSString -> Callback a -> IO ()

foreign import javascript unsafe "global.emitter"
    js_getRequireEmitter :: IO Object
