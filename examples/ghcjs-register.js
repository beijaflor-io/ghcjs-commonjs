const childProcess = require('child_process');
const fs = require('fs');
const path = require('path');
const util = require('util');

function stripBOM(content) {
  if (content.charCodeAt(0) === 0xFEFF) {
    content = content.slice(1);
  }
  return content;
}

function generateIndex(fp) {
  const rts = fs.readFileSync(path.join(fp, '/rts.js'));
  const lib = fs.readFileSync(path.join(fp, '/lib.js'));
  const out = fs.readFileSync(path.join(fp, '/out.js'));

  return stripBOM(`
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
  `);
}

function addIndex(fp) {
  const idx = generateIndex(fp);
  fs.writeFileSync(path.join(fp, 'index.js'), idx);
}

function ghcjsRequire(fp) {
  addIndex(fp);
  return require(fp);
}

exports = module.exports = ghcjsRequire;
exports.addIndex = addIndex;
