# ghcjs-commonjs-examples
This is a collection of runnable examples for **ghcjs-commonjs**, there's a
`Vagrantfile` and `Dockerfile` in this directory so you can get everything up
and running quickly.

## `hello-world` Getting Started
Take a look at the **`hello-world`** example to start. It shows off how to call
Haskell functions from JavaScript and run code after it has finished.

## `hello-variable-name` Passing arguments to functions
**hello-variable-name** shows off how to pass arguments from JavaScript onto
Haskell functions. Anything that may be converted from a JavaScript value onto a
Haskell value will be automatically converted for you.

## `fibonacci` Passing arguments and yielding return values
**fibonacci** shows off how to pass arguments and get something back from/to
Haskell/JavaScript. It shows that we may wrap pure and unpure computations

## `failure` Handling errors from Haskell in JavaScript
**failure** shows that any errors thrown from the Haskell world will result in
the Promise being rejected.
