# ghcjs-commonjs-webpack
GHCJS CommonJS webpack example.

## Building
Running:
```
npm install
```

Will install dependencies. To build you can run:
```
npm run build
```

## Running
The generated code should be executable in **Node.js** and the **Browser**.

## Webpack configuration
The webpack configuration is:
```javascript
const webpack = require('webpack');
exports = module.exports = {
  module: {
    loaders: [
      {
        test: /\.hs$/,
        loader: 'ghcjs-loader',
      },
      {
        test: /\.jsx?$/,
        loader: 'babel-loader',
      },
    ],
  },
  entry: './js/index.js',
  output: {
    path: './dist',
    filename: 'index.bundle.js',
  },
  plugins: [
  ].concat(process.env.NODE_ENV === 'production' ? [
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false,
      }
    }),
  ] : [])
};
```

The loader will automatically run `stack ghc` for the required executables.
