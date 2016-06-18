# ghcjs-commonjs
**ghcjs-commonjs** is a _work-in-progress_ collection of little hacks to make
GHCJS and CommonJS integration less troublesome.

By that we mean:
- Easy implementation of calling Haskell code from JavaScript code
- Easy implementation of calling JavaScript code from Haskell

The first point is where the most friction is, since the GHCJS FFI is pretty
stellar.

We provide the following tools:

- `ghcjs-require`     - **Calling Haskell from Node.js and CommonJS**
- `ghcjs-register`    - **require('./MyHaskellModule.hs')**
- `ghcjs-loader`      - **A webpack loader for GHCJS**

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
});
```

This is `Main.hs`:
```haskell
import Control.Concurrent (threadDelay)
import qualified GHCJS.CommonJS as CJS (exportMain, pack)
someFunction = do
    putStrLn "Waiting for a second"
    threadDelay (1000 * 1000)
    putStrLn "Done!"
main = CJS.exportMain [ CJS.pack ("someFunction", someFunction)
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
