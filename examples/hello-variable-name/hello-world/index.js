const ghcjsRequire = require('ghcjs-require');
const HelloWorld = ghcjsRequire(module, 'ghcjs-commonjs-hello-world');

HelloWorld(({wrapped}) => {
  wrapped.sayHello().then(() => {
    console.log('And I\'m a JavaScript');
  });
});
