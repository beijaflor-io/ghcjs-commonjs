# ghcjs-commonjs-examples
This is a collection of runnable examples for **ghcjs-commonjs**.

## [`hello-world` Getting Started](/examples/hello-world)
Take a look at the **`hello-world`** example to start. It shows off how to call
Haskell functions from JavaScript and run code after it has finished.

## [`hello-variable-name` Passing arguments to functions](/examples/hello-variable-name)
**hello-variable-name** shows off how to pass arguments from JavaScript onto
Haskell functions. Anything that may be converted from a JavaScript value onto a
Haskell value will be automatically converted for you.

## [`fibonacci` Passing arguments and yielding return values](/examples/fibonacci)
**fibonacci** shows off how to pass arguments and get something back from/to
Haskell/JavaScript. It shows that we may wrap pure and unpure computations

## [`failure` Handling errors from Haskell in JavaScript](/examples/failure)
**failure** shows that any errors thrown from the Haskell world will result in
the Promise being rejected.

## [`webpack` Basic Haskell webpack build system integration](/examples/webpack)
**webpack** shows off how to `require('Stuff.hs')` from JavaScript using
webpack this integration is still primitive but easy to improve.

## [`pandoc` Exposing existing Haskell packages](/examples/pandoc)
**pandoc** exports a basic JavaScript API, which let's JavaScript users run
PanDoc natively. It works on Node.js and the browser, through `node-main.js` and
webpack, but `webpack` takes 1 hour and many gigabytes of RAM to compile...
