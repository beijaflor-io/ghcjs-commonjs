{-# LANGUAGE JavaScriptFFI     #-}
{-# LANGUAGE OverloadedStrings #-}

import           Prelude           hiding (readFile)

import           Data.ByteString   (ByteString)
import           Data.JSString     ()
import qualified Data.JSString     as JSString
import           Data.String
import           GHCJS.Buffer
import           GHCJS.Foreign
import           GHCJS.Types
import           JavaScript.Array
import           JavaScript.Object

foreign import javascript unsafe "require($1)"
  require :: JSString -> IO Object

foreign import javascript unsafe "require('fs').readFileSync($1)"
  js_readFile :: JSString -> IO Object

foreign import javascript safe "$1.toString()"
  js_bufToString :: Object -> JSString

readFile :: FilePath -> IO String
readFile fp = do
    fc <- js_readFile (JSString.pack fp)
    return (JSString.unpack (js_bufToString fc))

main = do
    putStrLn "Calling `require \"fs\"`"
    fs <- require $ "fs"
    props <- listProps fs
    print props

    buf <- readFile "./HaskellFromNode.js"
    putStrLn buf
