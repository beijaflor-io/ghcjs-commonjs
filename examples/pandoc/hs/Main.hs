import qualified Data.ByteString.Lazy.Char8 as ByteString
import           GHCJS.CommonJS             (exportMain, exports)
import           Text.Pandoc

convert :: String -> String -> String -> IO String
convert inp out contents = do
    let Just reader = lookup inp readers
        Just writer = lookup out writers
    pd <- runReader reader contents
    runWriter writer pd
  where
    runReader reader cts = case reader of
        StringReader r -> do
            Right pd <- r def cts
            return pd
        ByteStringReader r -> do
            Right (pd, _) <- r def (ByteString.pack contents)
            return pd
    runWriter writer pd = case writer of
        PureStringWriter w -> return $ w def pd
        IOStringWriter w -> w def pd
        IOByteStringWriter w -> ByteString.unpack <$> w def pd

main :: IO ()
main =
    exportMain
        [ "convert" `exports` convert
        , "writers" `exports` map fst writers
        , "readers" `exports` map fst readers
        ]
