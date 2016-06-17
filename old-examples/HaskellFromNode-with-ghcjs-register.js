const ghcjsRequire = require('./ghcjs-register');
const emitter = ghcjsRequire('./EventEmitter.jsexe')();
console.log('[javascript] Listening for something');

emitter.on('something', (value) => {
  console.log(`[javascript] Got something: ${JSON.stringify(value)}`);
});


console.log('[javascript] Sending "foo"');
emitter.emit('foo');

setInterval(() => {
  console.log('[javascript] Sending "foo"');
  emitter.emit('foo');
}, 1000);
