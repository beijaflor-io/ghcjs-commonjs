const webpack = require('webpack');

exports = module.exports = {
  module: {
    loaders: [
      {
        test: /\.hs$/,
        loader: 'ghcjs-loader',
      },
    ],
    noParse: [
      /node_modules/,
    ],
  },
  entry: './src/index.js',
  output: {
    path: './dist',
    filename: 'index.bundle.js',
  },
  plugins: [
    new webpack.ContextReplacementPlugin(/.*$/, /NEVER_MATCH^/),
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false,
      }
    }),
  ],
};
