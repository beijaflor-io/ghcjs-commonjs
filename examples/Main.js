const ghcjsRequire = require('./ghcjs-require');
const main = ghcjsRequire('./Main.jsexe')();

main.emitter.once('ghcjs-require:loaded', () => {
  console.log('[javascript] Haskell runtime loaded!');
  console.log('[javascript] Calling helloWorld...');
  main.exports.helloWorld();

  console.log('[javascript] Sending message to call launchTheMissiles...');
  main.emitter.emit('ghcjs-require:runexport', 'launchTheMissiles', (err, x) => {
    console.log(`[javascript] launchTheMissiles ended yielding: ${x}`);

    console.log('[javascript] Running launchTheMissiles as wrapped function that returns promise');
    main.wrapped.launchTheMissiles().then((x) => {
      console.log(`[javascript] launchTheMissiles promised ended yielding: ${x}`);
    });
  });
});
