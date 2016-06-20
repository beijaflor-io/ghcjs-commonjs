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
    //new webpack.ContextReplacementPlugin(/.*$/, /NEVER_MATCH^/),
    //new webpack.ContextReplacementPlugin(/.*$/, /NEVER_MATCH^/),
  ].concat(process.env.NODE_ENV === 'production' ? [
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false,
      }
    }),
  ] : [])
};
