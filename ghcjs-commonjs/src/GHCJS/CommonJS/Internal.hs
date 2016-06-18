module GHCJS.CommonJS.Internal where

import           Data.JSString
import           GHCJS.Foreign.Callback
import           GHCJS.Types
import           JavaScript.Array
import           JavaScript.Object

foreign import javascript unsafe "$r = require($1)"
    js_require :: JSString -> IO JSVal

foreign import javascript unsafe "global.wrappedExports.push($1)"
    js_registerWrapped :: JSString -> IO ()

foreign import javascript unsafe "global.exports[$1] = $2"
    js_export :: JSString -> Callback a -> IO ()

foreign import javascript unsafe "global.emitter"
    js_getRequireEmitter :: IO Object

foreign import javascript unsafe "$1()"
   js_call0 :: JSVal -> IO ()

foreign import javascript unsafe "$1($2)"
   js_call1 :: JSVal -> JSVal -> IO ()

foreign import javascript unsafe "$1($2, $3)"
   js_call2 :: JSVal -> JSVal -> JSVal -> IO ()

foreign import javascript unsafe "$1($2, $3, $4)"
   js_call3 :: JSVal -> JSVal -> JSVal -> JSVal -> IO ()

foreign import javascript unsafe "$1.apply(null, $2)"
   js_apply :: JSVal -> JSArray -> IO ()
