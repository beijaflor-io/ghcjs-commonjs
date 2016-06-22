const ghcjsRequire = require('ghcjs-require');
const Main = ghcjsRequire(module, 'ghcjs-commonjs-pandoc');
Main(({wrapped}) => {
  wrapped.convert('markdown', 'html', '# Stuff here').then((res) => {
    console.log(res);
    process.exit(0);
  });
});
