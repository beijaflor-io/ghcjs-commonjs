const ghcjsRequire = require('ghcjs-require');
const Main = ghcjsRequire(module, 'README');

Main(({wrapped}) => {
  wrapped.someFunction().then(() => console.log('someFunction is over'));
});
