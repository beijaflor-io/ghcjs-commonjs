const childProcess = require('child_process');
const util = require('util');
const fs = require('fs');

function stripBOM(content) {
  if (content.charCodeAt(0) === 0xFEFF) {
    content = content.slice(1);
  }
  return content;
}

function haskellFromNode(module, fp) {
  console.log('Compiling ' + fp + '...');
  childProcess.execSync('stack ghc --compiler ghcjs-0.2.0.20160414_ghc-7.10.3 -- -o HaskellFromNode.jsexe ' + fp, {
    stdio: 'inherit'
  });
  console.log('Compiled ' + fp + '!');
  const rts = fs.readFileSync('./HaskellFromNode.jsexe/rts.js');
  const lib = fs.readFileSync('./HaskellFromNode.jsexe/lib.js');
  const out = fs.readFileSync('./HaskellFromNode.jsexe/out.js');
  global.main=function() {h$run(h$mainZCMainzimain);}

  return module._compile(stripBOM(`
    exports = module.exports = function bootAndRunHaskellModule() {
      var md = exports.boot();
      md.run();
      return md.emitter;
    };

    exports.boot = function bootHaskellModule() {
      return (function(global) {
        ${rts.toString()}
        ${lib.toString()}
        ${out.toString()}
        ;

        var EventEmitter = require('events');
        global.emitter = new EventEmitter();
        global.run = function() {
          return h$run(h$mainZCMainzimain);
        };

        return global;
      })({});
    };
  `), fp);
}

require.extensions['.hs'] = haskellFromNode;

console.log(">>> require('HaskellFromNode')");
const HaskellFromNode = require('./HaskellFromNode.hs');
console.log('>>> HaskellFromNode =', util.inspect(HaskellFromNode));
console.log('>>> HaskellFromNode()');

const emitter = HaskellFromNode();
console.log('We\'re in control again, waiting for event')
emitter.on('hello', () => {
  console.log('Haskell has finished!', 'BUYA');
  process.exit(0);
});
