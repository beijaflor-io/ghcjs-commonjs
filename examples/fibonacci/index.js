const ghcjsRequire = require('ghcjs-require');
const HelloWorld = ghcjsRequire(module, 'ghcjs-commonjs-fibonacci');

HelloWorld(({wrapped}) => {
  wrapped.fibs(10).then((fibs) => {
    console.log('Haskell calculated', fibs);

    wrapped.fibsIO(10).then((fibs) => {
      console.log('Haskell calculated', fibs, 'after logging stuff to the console');
      process.exit(0);
    });
  });
});
