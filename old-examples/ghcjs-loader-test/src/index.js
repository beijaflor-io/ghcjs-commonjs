const Main = require('../Main.hs');
console.log('[javascript] Hello there');
console.log('[javascript] Main =', Main);
Main(function (main) {
  main.wrapped.launchTheMissiles();
  main.wrapped.launchTheMissiles();
  main.wrapped.launchTheMissiles();
  main.wrapped.helloWorld();
});
