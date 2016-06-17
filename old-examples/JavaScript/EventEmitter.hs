module JavaScript.EventEmitter
    (
      newEmitter
    , emit
    , on0
    , on1
    , on2
    , on3
    , emit0
    , emit1
    , emit2
    , emit3
    , unEmitter
    , emitter
    , EventEmitter
    )
  where

import           Data.String                      (fromString)
import           GHCJS.Foreign.Callback           (asyncCallback,
                                                   asyncCallback1,
                                                   asyncCallback2,
                                                   asyncCallback3)
import           GHCJS.Types                      (JSVal)
import           JavaScript.Array                 (fromList)
import           JavaScript.EventEmitter.Internal
import           JavaScript.Object                (Object)

newtype EventEmitter = EventEmitter Object

-- | Creates a new EventEmitter
newEmitter :: IO EventEmitter
newEmitter = EventEmitter <$> js_newEmitter

-- | Emits an event on an EventEmitter
emit :: EventEmitter -> String -> [JSVal] -> IO JSVal
emit (EventEmitter emitter) name args =
    let name' = fromString name
    in case args of
        []               -> js_emit0 emitter name'
        [a1]             -> js_emit1 emitter name' a1
        [a1, a2]         -> js_emit2 emitter name' a1 a2
        [a1, a2, a3]     -> js_emit3 emitter name' a1 a2 a3
        [a1, a2, a3, a4] -> js_emit4 emitter name' a1 a2 a3 a4
        as               -> js_emitAll emitter name' (fromList as)

emit0 :: EventEmitter -> String -> IO JSVal
emit0 e n = emit e n []

emit1 :: EventEmitter -> String -> JSVal -> IO JSVal
emit1 e n v = emit e n [v]

emit2 :: EventEmitter -> String -> JSVal -> JSVal -> IO JSVal
emit2 e n v1 v2 = emit e n [v1, v2]

emit3 :: EventEmitter -> String -> JSVal -> JSVal -> JSVal -> IO JSVal
emit3 e n v1 v2 v3 = emit e n [v1, v2, v3]

-- | Listens for an event that passes no arguments on an EventEmitter
on0 :: EventEmitter
   -- ^ The EventEmitter to listen on
   -> String
   -- ^ The name of the event
   -> IO ()
   -- ^ The haskell action to run
   -> IO ()
on0 (EventEmitter emitter) name action = do
    let name' = fromString name
    callback <- asyncCallback action
    js_on emitter name' callback

-- | Listens for an event that passes 1 argument on an EventEmitter
on1 :: EventEmitter
   -- ^ The EventEmitter to listen on
   -> String
   -- ^ The name of the event
   -> (JSVal -> IO ())
   -- ^ The haskell action to run
   -> IO ()
on1 (EventEmitter emitter) name action = do
    let name' = fromString name
    callback <- asyncCallback1 action
    js_on emitter name' callback

-- | Listens for an event that passes 2 arguments on an EventEmitter
on2 :: EventEmitter
   -- ^ The EventEmitter to listen on
   -> String
   -- ^ The name of the event
   -> (JSVal -> JSVal -> IO ())
   -- ^ The haskell action to run
   -> IO ()
on2 (EventEmitter emitter) name action = do
    let name' = fromString name
    callback <- asyncCallback2 action
    js_on emitter name' callback

-- | Listens for an event that passes 3 arguments on an EventEmitter
--
-- For more arguments, use the Foreign function
on3 :: EventEmitter
   -- ^ The EventEmitter to listen on
   -> String
   -- ^ The name of the event
   -> (JSVal -> JSVal -> JSVal -> IO ())
   -- ^ The haskell action to run
   -> IO ()
on3 (EventEmitter emitter) name action = do
    let name' = fromString name
    callback <- asyncCallback3 action
    js_on emitter name' callback

-- | Casts an EventEmitter onto a JSVal
unEmitter :: EventEmitter -> Object
unEmitter (EventEmitter v) = v

-- | Casts a JSVal onto an EventEmitter
emitter :: Object -> EventEmitter
emitter = EventEmitter
