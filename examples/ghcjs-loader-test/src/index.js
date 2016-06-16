const Main = require('../../Main.hs');

console.log(Main);
Main(function (main) {
  main.wrapped.launchTheMissiles();
  main.wrapped.launchTheMissiles();
  main.wrapped.launchTheMissiles();
  main.wrapped.helloWorld();
});

console.log('[javascript] Hello world');
