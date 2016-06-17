const ghcjsRequire = require('./ghcjs-require');
const Main = ghcjsRequire('./Main.jsexe');

Main(({wrapped, exports, emitter}) => {
  console.log('[javascript] Haskell runtime loaded!');
  console.log('[javascript] Calling helloWorld...');
  exports.helloWorld();

  console.log('[javascript] Sending message to call launchTheMissiles...');
  emitter.emit('ghcjs-require:runexport', 'launchTheMissiles', (err, x) => {
    console.log(`[javascript] launchTheMissiles ended yielding: ${x}`);

    console.log('[javascript] Running launchTheMissiles as wrapped function that returns promise');
    wrapped.launchTheMissiles().then((x) => {
      console.log(`[javascript] launchTheMissiles promised ended yielding: ${x}`);
    });
  });
});
