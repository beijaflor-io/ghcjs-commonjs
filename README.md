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

## License
All code under this repository is licensed under the MIT license.
