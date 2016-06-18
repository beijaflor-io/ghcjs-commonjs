{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE FlexibleInstances         #-}
{-# LANGUAGE GADTs                     #-}
{-# LANGUAGE ImpredicativeTypes        #-}
{-# LANGUAGE LambdaCase                #-}
{-# LANGUAGE OverlappingInstances      #-}
{-# LANGUAGE ScopedTypeVariables       #-}
module GHCJS.CommonJS
  where

import           Control.Concurrent
import           Control.Exception
import           Control.Monad
import qualified Data.JSString           as JSString (unpack)
import qualified Data.Map.Strict         as Map
import           Data.String
import           GHCJS.Foreign.Callback
import           GHCJS.Marshal
import           GHCJS.Types
import qualified JavaScript.Array        as JSArray (fromList)
import           JavaScript.EventEmitter

import           GHCJS.CommonJS.Internal
import           System.IO.Unsafe

instance ToJSVal () where
    toJSVal _ = return nullRef

data CommonJSExportArity t = CommonJSExportArity Int
                           | CommonJSExportArityApply

type CommonJSExport = [JSVal] -> IO [JSVal]

class ToCommonJSExport t where
    exportName :: t -> String
    toCommonJSExport :: t -> CommonJSExport
    arity :: CommonJSExportArity t

instance ToCommonJSExport (String, IO ()) where
    exportName = fst
    toCommonJSExport (_, action) _ = void action >> return []
    arity = CommonJSExportArity 0

instance (FromJSVal a, ToJSVal b) => ToCommonJSExport (String, a -> IO b) where
    exportName = fst
    toCommonJSExport (n, action) (a:_) = do
        v <- fromJSValIO n a >>= action
        jsV <- toJSVal v
        return [jsV]
    toCommonJSExport (n, _) _ = error ("Missing required argument to " ++ n)
    arity = CommonJSExportArity 1

instance (FromJSVal a1, FromJSVal a2, ToJSVal b) => ToCommonJSExport (String, a1 -> a2 -> IO b) where
    exportName = fst
    toCommonJSExport (n, action) (a1:a2:_) = do
        a1' <- fromJSValIO n a1
        a2' <- fromJSValIO n a2
        v <- action a1' a2'
        jsV <- toJSVal v
        return [jsV]
    toCommonJSExport (n, _) _ = error ("Missing required argument(s) to " ++ n)
    arity = CommonJSExportArity 2

instance (FromJSVal a1, FromJSVal a2, FromJSVal a3, ToJSVal b) => ToCommonJSExport (String, a1 -> a2 -> a3 -> IO b) where
    exportName = fst
    toCommonJSExport (n, action) (a1:a2:a3:_) = do
        a1' <- fromJSValIO n a1
        a2' <- fromJSValIO n a2
        a3' <- fromJSValIO n a3
        v <- action a1' a2' a3'
        jsV <- toJSVal v
        return [jsV]
    toCommonJSExport (n, _) _ = error ("Missing required argument(s) to " ++ n)
    arity = CommonJSExportArity 2

instance (FromJSVal a, ToJSVal b) => ToCommonJSExport (String, [a] -> IO [b]) where
    exportName = fst
    toCommonJSExport (n, action) as = do
        as' <- fromJSValListOfIO n as
        v <- action as'
        mapM toJSVal v
    arity = CommonJSExportArityApply

instance ToCommonJSExport (String, [JSVal] -> IO [JSVal]) where
    exportName = fst
    toCommonJSExport = snd
    arity = CommonJSExportArityApply

instance (ToJSVal a) => ToCommonJSExport (String, IO a) where
    exportName = fst
    toCommonJSExport (_, action) _ = do
        v <- action
        mv <- toJSVal v
        return [mv]
    arity = CommonJSExportArity 0

instance (FromJSVal b, ToJSVal a) => ToCommonJSExport (String, b -> a) where
    exportName = fst
    toCommonJSExport (n, action) (a:_) = do
        a' <- fromJSValIO n a
        let v = action a'
        mv <- toJSVal v
        return [mv]
    toCommonJSExport (n, _) _ = error ("Missing required argument(s) to " ++ n)
    arity = CommonJSExportArity 1

instance (ToJSVal a) => ToCommonJSExport (String, a) where
    exportName = fst
    toCommonJSExport (_, action) _ = do
        let v = action
        mv <- toJSVal v
        return [mv]
    arity = CommonJSExportArity 0

fromJSValListOfIO :: FromJSVal a => String -> [JSVal] -> IO [a]
fromJSValListOfIO n as = do
    asms <- mapM fromJSVal as -- :: FromJSVal a => IO [Maybe a]
    case sequence asms of -- :: Maybe [a] of
        Nothing -> error ("Wrong type of arguments suplied to " ++ n ++
                      ". All arguments should have the same type")
        Just as' -> return as'

fromJSValIO :: FromJSVal a => String -> JSVal -> IO a
fromJSValIO n a = fromJSVal a >>= \case
    Nothing -> error ("Wrong type of argument suplied to " ++ n)
    Just a' -> return a'

-- data Export where
--     Export :: CommonJSExport e => e -> Export
    --  forall e . CommonJSExport e => Export e
type ExportMap = Map.Map String CommonJSExport

defaultMain :: IO ()
defaultMain = do
    em <- getRequireEmitter
    on3 em "ghcjs-require:runexport" onRunExport
    void $ emit0 em "ghcjs-require:loaded"
    return ()

exportMain :: (Foldable t) => t (String, CommonJSExport) -> IO ()
exportMain es = do
    mapM_ (uncurry exportWrapped) es
    defaultMain

fibs :: [Int]
fibs = 1 : 1 : zipWith (+) fibs (tail fibs)

pack :: ToCommonJSExport (String, e) => (String, e) -> (String, CommonJSExport)
pack e = (exportName e, toCommonJSExport e)

test =
    exportMain [ pack ("hello", print "Hello")
               , pack ("fibs", \n -> (take n fibs))
               , pack ("yo", print "yo")
               ]

foreign import javascript unsafe "$r = new Error($1)"
    js_error :: JSString -> JSVal

onRunExport :: JSVal -> JSVal -> JSVal -> IO ()
onRunExport name args cb = do
    eret <- try run
    case eret of
        Right ret ->
            call cb (nullRef : ret)
        Left (SomeException e) ->
            call cb [js_error (fromString (show e))]
  where
    run = do
        Just str <- fromJSVal name :: IO (Maybe JSString)
        let hsName = JSString.unpack str
        maction <- getExport hsName
        case maction of
            Nothing -> error ("No function " ++ hsName ++ " exported")
            Just action -> fromJSValListOf args >>= \case
                Nothing -> error ("Second parameter to the ghcjs-require:runexport " ++
                                  "event should be a list of arguments")
                Just args' -> action args'

call :: JSVal -> [JSVal] -> IO ()
call fn [] = js_call0 fn
call fn [a1] = js_call1 fn a1
call fn [a1, a2] = js_call2 fn a1 a2
call fn [a1, a2, a3] = js_call3 fn a1 a2 a3
call fn args = js_apply fn (JSArray.fromList args)

exports :: MVar ExportMap
exports = unsafePerformIO $ newMVar Map.empty
{-# NOINLINE exports #-}

getExport :: String -> IO (Maybe CommonJSExport)
getExport name = do
    es <- readMVar exports
    return $ Map.lookup name es

registerExport' :: (String, CommonJSExport) -> IO ()
registerExport' e = modifyMVar_ exports $ \es ->
    return $ uncurry Map.insert e es

registerExport :: ToCommonJSExport e => e -> IO ()
registerExport e =
    registerExport' (exportName e, toCommonJSExport e)

require :: String -> IO JSVal
require = js_require . fromString

exportWrapped :: ToCommonJSExport (String, e) => String -> e -> IO ()
exportWrapped name action = do
    registerExport (name, action)
    let name' = fromString name
    js_registerWrapped name'

export :: String -> IO () -> IO ()
export name action = do
    callback <- asyncCallback action
    let name' = fromString name
    js_export name' callback

getRequireEmitter :: IO EventEmitter
getRequireEmitter = emitter <$> js_getRequireEmitter
