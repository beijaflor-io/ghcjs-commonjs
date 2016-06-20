const ghcjsRequire = require('ghcjs-require');
const Failure = ghcjsRequire(module, 'ghcjs-commonjs-failure');

Failure(({wrapped}) => {
  wrapped.willThrowWithPairNumbers(11).then(() => {
    console.log('[javascript] All good');
    wrapped.willThrowWithPairNumbers(2)
      .then(() => {
        console.log('THIS SHOULDN\'T RUN REPORT IT AS A BUG AT:');
        console.log('https://github.com/beijaflor-io/ghcjs-commonjs');
      }, (err) => {
        console.log('Haskell failed with:', err);

        console.log('----');
        console.log('But the Haskell world didn\'t die');
        wrapped.willThrowWithPairNumbers(3).then(() => {
          console.log('[javascript] All good');
          process.exit(0);
        });
      });
  });
});
