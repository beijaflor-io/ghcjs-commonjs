# ghcjs-commonjs
## `exports :: ToCommonJSExport (String, e) => String -> e -> (String, CommonJSExport)`
Converts a name and value to a `CommonJSExport`.

## `exportMain :: (Foldable t) => t (String, CommonJSExport) -> IO ()`
Runs the event listener for running Haskell code from the JavaScript main.
