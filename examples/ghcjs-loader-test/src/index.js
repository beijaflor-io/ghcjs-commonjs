const Main = require('../../Main.hs');

console.log(Main);
Main(({wrapped}) => {
  wrapped.launchTheMissiles();
});

console.log('Hello world');
