const ghcjsRequire = require('./ghcjs-require');
const main = ghcjsRequire('./Main.jsexe')();

main.emitter.once('ghcjs-require:loaded', () => {
  console.log('[javascript] Haskell runtime loaded!');
  main.exports.helloWorld();

  console.log('[javascript] Sending message...');
  main.emitter.emit('ghcjs-require:runexport', 'launchTheMissiles', (err, x) => {
    console.log(`[javascript] launchTheMissiles ended yielding: ${x}`);
  });
});
