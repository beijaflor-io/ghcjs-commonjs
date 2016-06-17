module JavaScript.EventEmitter.Internal where

import           Control.Concurrent
import           Control.Monad
import           Data.JSString
import           Data.String
import           GHCJS.Foreign
import           GHCJS.Foreign.Callback
import           GHCJS.Types
import           JavaScript.Array
import           JavaScript.Object

foreign import javascript unsafe "$r = $1.emit($2)"
    js_emit0 :: Object -> JSString -> IO JSVal

foreign import javascript unsafe "$r = $1.emit($2, $3)"
    js_emit1 :: Object -> JSString -> JSVal -> IO JSVal

foreign import javascript unsafe "$r = $1.emit($2, $3, $4)"
    js_emit2 :: Object -> JSString -> JSVal -> JSVal -> IO JSVal

foreign import javascript unsafe "$r = $1.emit($2, $3, $4, $5)"
    js_emit3 :: Object -> JSString -> JSVal -> JSVal -> JSVal -> IO JSVal

foreign import javascript unsafe "$r = $1.emit($2, $3, $4, $5)"
    js_emit4 :: Object -> JSString -> JSVal -> JSVal -> JSVal -> JSVal -> IO JSVal

foreign import javascript unsafe "$r = $1.emit.apply($1, [$2].concat($3))"
    js_emitAll :: Object -> JSString -> JSArray -> IO JSVal

foreign import javascript unsafe "$1.on($2, $3)"
    js_on :: Object -> JSString -> Callback a -> IO ()

foreign import javascript unsafe "$r = new EventEmitter()"
    js_newEmitter :: IO Object
