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

function generateWrapper(fp) {
  const rts = fs.readFileSync(path.join(fp, '/rts.js'));
  const lib = fs.readFileSync(path.join(fp, '/lib.js'));
  const out = fs.readFileSync(path.join(fp, '/out.js'));

  return stripBOM(`
    function mapValues(obj, fn) {
      const keys = Object.keys(obj);
      const ret = {}
      for (var i = 0, len = keys.length; i < len; i++) {
        const key = keys[i];
        ret[key] = fn(obj[key], key);
      }
      return ret;
    }

    exports = module.exports = function bootAndRunHaskellModule() {
      const md = exports.boot();

      md.emitter.on('ghcjs-require:loaded', () => {
        md.wrapped = mapValues(md.exports, (fn, key) => {
          return function() {
            return new Promise((resolve, reject) => {
              md.emitter.emit('ghcjs-require:runexport', key, (err, result) => {
                if (err) return reject(err);
                resolve(result);
              });
            });
          };
        });
      });

      // Wait a tick so JavaScript land can bootstrap to the load event
      process.nextTick(() => {
        md.run();
      });

      return md;
    };

    exports.boot = function bootHaskellModule() {
      const global = {};
      global.exports = {};
      return (function(global, exports, module) {
        ${rts.toString()}
        ${lib.toString()}
        ${out.toString()}
        ;

        var EventEmitter = require('events');

        global.emitter = new EventEmitter();

        global.startAction = function() {
          const uuid = require('uuid');
          global.promises[uuid] = new Promise((resolve, reject) => {
            emitter.on('finishAction:' + uuid, () => resolve(arguments));
          });
          return uuid.v1();
        };

        global.finishAction = function() {
          const uuid = require('uuid');
          global.promises[uuid] = new Promise((resolve, reject) => {
            emitter.on('finishAction:' + uuid, () => resolve(arguments));
          });
          return uuid.v1();
        };

        global.run = function() {
          return h$run(h$mainZCMainzimain);
        };

        global.runSync = function() {
          return h$runSync(h$mainZCMainzimain);
        };

        return global;
      })(global, global.exports, module);
    };
  `);
}

function addWrapper(fp) {
  const idx = generateWrapper(fp);
  fs.writeFileSync(path.join(fp, 'index.js'), idx);
}

function ghcjsRequire(fp) {
  addWrapper(fp);
  return require(fp);
}

exports = module.exports = ghcjsRequire;
exports.addWrapper = addWrapper;
exports.generateWrapper = generateWrapper;
