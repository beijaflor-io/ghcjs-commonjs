const childProcess = require('child_process');
const fs = require('fs');
const chalk = require('chalk');
const ghcjsRequire = require('ghcjs-require');
const path = require('path');

const GHCJS_COMMAND = 'stack ghc --compiler ghcjs-0.2.0.20160414_ghc-7.10.3';
const CLOSURE_COMPILER_COMMAND = 'closure-compiler -O ADVANCED';

function compileSync(loader, content) {
  const dirname = loader.context;
  const input = loader.resourcePath;
  const filename = path.basename(input, '.hs');
  const output = path.join(dirname, filename + '.jsexe');

  const cmd = `${GHCJS_COMMAND} -- -DGHCJS_BROWSER -o ${output} ${input}`;
  console.log(
    chalk.blue.bold('[ghcjs] >>>'),
    cmd
  );
  childProcess.execSync(cmd, {
    stdio: 'inherit',
    cwd: dirname,
  });

  return output;
}

function runClosureCompiler(loader, jsExePath) {
  const wrapperPath = path.join(jsExePath, 'index.js');
  const minPath = path.join(jsExePath, 'index.min.js');

  const fcmdP = `gsed -i s/goog.provide.*// ${wrapperPath}`;
  console.log(chalk.blue.bold('[ghcjs] >>>'), fcmdP);
  childProcess.execSync(fcmdP, {
    stdio: 'inherit',
    cwd: loader.context,
  });

  const fcmdR = `gsed -i s/goog.require.*// ${wrapperPath}`;
  console.log(chalk.blue.bold('[ghcjs] >>>'), fcmdR);
  childProcess.execSync(fcmdR, {
    stdio: 'inherit',
    cwd: loader.context,
  });

  const cmd = `${CLOSURE_COMPILER_COMMAND} ${wrapperPath} > ${minPath}`;
  console.log(chalk.blue.bold('[ghcjs] >>>'), cmd);
  childProcess.execSync(cmd, {
    stdio: 'inherit',
    cwd: loader.context,
  });

  return minPath;
}

function patchWrapper(out) {
  return out.replace(/goog.require.*/gm, '').replace(/goog.provide.*/gm, '');
}

exports = module.exports = function ghcjsLoader(content) {
  const jsExePath = compileSync(this, content);

  const cwd = process.cwd();
  const relPath = path.relative(cwd, this.resourcePath);

  console.log(chalk.blue.bold('[ghcjs] >>>'), 'Generating wrapper...');
  // const minPath = runClosureCompiler(this, jsExePath);
  const out = ghcjsRequire.generateWrapper(
    jsExePath
    // ,
    // fs.readFileSync(minPath).toString()
  );
  console.log(chalk.blue.bold('[ghcjs] >>>'), 'Finished compiling ' + relPath);
  return patchWrapper(out);
};
