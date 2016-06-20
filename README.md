# ghcjs-commonjs
**ghcjs-commonjs** is a _work-in-progress_ collection of little hacks to make
GHCJS generated JavaScript and CommonJS integration less troublesome.

**This hasn't been tested in production yet, so try the examples and report
any issues that you have**

We provide the following tools:

- `ghcjs-require`     - **Calling Haskell from Node.js and CommonJS**
- `ghcjs-commonjs`    - **Exposing Haskell to be called from CommonJS**
- `ghcjs-register`    - **require('./MyHaskellModule.hs')**
- `ghcjs-loader`      - **A webpack loader for GHCJS**

See the [examples](/examples/README.md)!

## `ghcjs-require`
Utilities for loading GHCJS `.jsexe`s from CommonJS land.

### Callling Haskell from JavaScript
This is `main.js`:
```javascript
const ghcjsRequire = require('ghcjs-require');
const Main = ghcjsRequire(module, './Main.jsexe');
// ^^ This is a function that boots the Haskell RTS
Main(({wrapped}) => { // <- This callback is executed after the RTS is loaded
  wrapped.someFunction().then(() => console.log('someFunction is over'));
  // ^^ This function was generated, it'll call Haskell code asynchronously and
  //    return a promise to the result (the result needs to be a JavaScript
  //    value)

  wrapped.hello('John').then((ret) => console.log(ret));
  // ^^ Arguments and return values are automatically (de-)serialized we can use
  //    multi-arg functions, IO actions and pure values
});
```

This is `Main.hs`:
```haskell
import Control.Concurrent (threadDelay)
import GHCJS.CommonJS (exportMain, exports)
someFunction = do
    putStrLn "Waiting for a second"
    threadDelay (1000 * 1000)
    putStrLn "Done!"
main = exportMain [ "someFunction" `exports` someFunction
                  , "hello" `exports` \name -> "Hello " ++ name
                  ]
```

## `ghcjs-register`
On the likes of `coffee-script/register` or `babel-register`:
```
require('ghcjs-register');
const Main = require('./Main.hs');
```

## `ghcjs-loader`
This is a `webpack` loader for GHCJS. See the examples.

## How does it work?
Following the guidelines set on
["Writing Atom plugins in Haskell using GHCJS"](http://edsko.net/2015/02/14/atom-haskell),
this project exports two main libraries: `ghcjs-require` is a JavaScript library
for wrapping GHCJS output in a CommonJS module and `ghcjs-commonjs` uses this
library's semantics to expose Haskell values to the JavaScript world.

Other than wrapping GHCJS' output in a module, `ghcjs-require` injects an
`EventEmitter` instance, which then serves as a message bus between Haskell and
JavaScript.

The `ghcjs-commonjs` package uses this bus through the `exports` and
`exportMain` primitives, listening for events on the emitter and executing
functions as requested.

The JavaScript side does some more wrapping to hide the event calling and
callbacks from the user, providing a promise based API.

The type of `exportMain` is:
```haskell
exportMain :: (Foldable t) => t (String, CommonJSExport) -> IO ()
```

So we can receive any `Foldable` instance of tuples of the export name to a
`CommonJSExport`. A `CommonJSExport` is:
```haskell
type CommonJSExport = [JSVal] -> IO [JSVal]
```

So a function that can take an arbitrary amount of arguments and return an
arbitrary amount of results

We then use an `exports` primitive:
```haskell
exports :: ToCommonJSExport (String, e) => String -> e -> (String, CommonJSExport)
```

This uses a _type-class_ `ToCommonJSExport`, which knows how to convert certain
Haskell values to `CommonJSExport`s, which then can be trivially wrapped onto
JavaScript functions.

To interact with the EventEmitter we use an internal, _work-in-progress_,
wrapper exposed in `JavaScript.EventEmitter` and a global variable which we get
from `ghcjs-register`.

This should be enough for Haskell/Node.js interop. For browsers, the `webpack`
integration should offer a way of using Haskell code in a state-of-the-art
JavaScript set-up.

All in all, it needs testing and examples that show that it adds or doesn't add
value, but I recommend you clone the repository and try the example code out.

## License
All code under this repository is licensed under the MIT license.
