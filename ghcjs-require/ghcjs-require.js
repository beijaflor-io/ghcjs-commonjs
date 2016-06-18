const childProcess = require('child_process');
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
    mod =
      rts.toString() +
      lib.toString() +
      out.toString();
  }

  return stripBOM(`
    exports = module.exports = function bootAndRunHaskellModule(onLoaded) {
      var md = exports.boot();

      md.emitter.on('ghcjs-require:loaded', function() {
        md.wrapped = md.wrappedExports.reduce(function(memo, key) {
          memo[key] = function() {
            var args = Array.prototype.slice.apply(arguments);
            return new Promise(function(resolve, reject) {
              md.emitter.emit('ghcjs-require:runexport', key, args, function(err, result) {
                if (err) return reject(err);
                resolve(result);
              });
            });
          };
          return memo;
        }, {});

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
      global.wrappedExports = [];
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

function find(root) {
  try {
    const ls = fs.readdirSync(process.cwd()); // Replace with the module
    if (ls.indexOf('.stack-work') > -1) {
      const installRoot = childProcess.execSync('stack path --dist-dir', {
        chdir: ls,
      }).toString().split('\n')[0];
      const bins = fs.readdirSync(path.join(installRoot, 'build', root));
      const exeIdx = bins.indexOf(root + '.jsexe');
      if (exeIdx > -1) {
        const out = path.join(installRoot, 'build', root, bins[exeIdx]);
        return out;
      }
    }
  } catch (err) {
    return null;
  }
}

const TYPE_ERROR =
  '`ghcjsRequire(module, fp)` takes 2 arguments:\n' +
  '              ^^^^^^\n' +
  'The first is the `module` "global"\n' +
  '`ghcjsRequire(module, fp)`\n' +
  '                      ^^\n' +
  'The second is the path to the *.jsexe bundle or\n' +
  'an executable name in a stack project in the cwd';

function ghcjsRequire(module, fp) {
  if (!(module.require && typeof module.require === 'function')) {
    throw new TypeError(
      'Invalid `module` suplied to ghcjsRequire\n' +
      TYPE_ERROR
    );
  }

  if (!(fp && typeof fp === 'string')) {
    throw new TypeError(
      'Invalid `fp` suplied to ghcjsRequire\n' +
      TYPE_ERROR
    );
  }

  if (path.extname(fp) !== '.jsexe') {
    const jsexe = find(fp);
    if (jsexe) {
      const root = childProcess
        .execSync('stack path --project-root')
        .toString()
        .split('\n')[0];
      return ghcjsRequire(module, path.join(root, jsexe))
    }

    throw new Error('Could not resolve Haskell source for ' + fp);
  }

  addWrapper(fp);
  return module.require(path.join(fp, 'index.js'));
}

exports = module.exports = ghcjsRequire;
exports.addWrapper = addWrapper;
exports.find = find;
exports.generateWrapper = generateWrapper;
