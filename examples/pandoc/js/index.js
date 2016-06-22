const Main = require('../hs/Main.hs');

Main(({wrapped}) => {
  wrapped.convert(
    'markdown',
    'html',
    '# Stuff here'
  ).then((output) => {
    console.log(output);
  });
});
