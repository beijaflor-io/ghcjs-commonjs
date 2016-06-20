const Main = require('../hs/Main.hs');
console.log('[javascript] Hello there');
console.log('[javascript] Main =', Main);
Main(({wrapped}) => {
  wrapped.launchTheMissiles();
  wrapped.launchTheMissiles();
  wrapped.launchTheMissiles();
  wrapped.helloWorld();
});
