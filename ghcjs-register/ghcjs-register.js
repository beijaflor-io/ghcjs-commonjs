const path = require('path');
const ghcjsRequire = require('ghcjs-require');

require.extensions['.hs'] = function(module, fp) {
  const jsexePath = path.join(path.dirname(fp), path.basename(fp, '.hs') + '.jsexe');
  return module._compile(
    ghcjsRequire.generateWrapper(jsexePath),
    fp
  );
};
