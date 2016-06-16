exports = module.exports = {
  module: {
    loaders: [
      {
        test: /\.hs/,
        loader: '../../ghcjs-loader.js',
      },
    ],
    noParse: [
      /node_modules/,
      /\.jsexe/,
      /\.hs/,
    ],
  },
  entry: './src/index.js',
  output: {
    path: './dist',
    filename: 'index.bundle.js',
  }
};
