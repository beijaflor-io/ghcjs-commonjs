const fs = require('fs');
const path = require('path');

function stripBOM(content) {
  if (content.charCodeAt(0) === 0xFEFF) {
    content = content.slice(1);
  }
  return content;
}

function generateWrapper(fp, mod) {
  if (!mod) {
    const rts = fs.readFileSync(path.join(fp, '/rts.js'));
    const lib = fs.readFileSync(path.join(fp, '/lib.js'));
    const out = fs.readFileSync(path.join(fp, '/out.js'));
    mod = rts.toString() + lib.toString() + out.toString();
  }

  return stripBOM(`
    function mapValues(obj, fn) {
      var keys = Object.keys(obj);
      var ret = {}
      for (var i = 0, len = keys.length; i < len; i++) {
        var key = keys[i];
        ret[key] = fn(obj[key], key);
      }
      return ret;
    }

    exports = module.exports = function bootAndRunHaskellModule(onLoaded) {
      var md = exports.boot();

      md.emitter.on('ghcjs-require:loaded', function() {
        md.wrapped = mapValues(md.exports, function(fn, key) {
          return function() {
            return new Promise(function(resolve, reject) {
              md.emitter.emit('ghcjs-require:runexport', key, function(err, result) {
                if (err) return reject(err);
                resolve(result);
              });
            });
          };
        });

        if (onLoaded) onLoaded(md);
      });

      // Wait a tick so JavaScript land can bootstrap to the load event
      process.nextTick(function() {
        md.run();
      });

      return md;
    };

    exports.boot = function bootHaskellModule() {
      var global = {};
      global.exports = {};
      return (function(global, exports, module) {
        ${mod}
        ;

        var EventEmitter = require('events');

        global.emitter = new EventEmitter();

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
