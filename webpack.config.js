const path = require('path');
const webpack = require('webpack');
const CopyWebpackPlugin = require('copy-webpack-plugin');
const MiniCssExtractPlugin = require("mini-css-extract-plugin");

module.exports = {
  mode: 'development',

  performance: {
     hints: false,
     maxEntrypointSize: 512000,
     maxAssetSize: 512000
  },

  entry: {
    'index': [
      path.resolve(__dirname, 'src/app.js')
    ]
  },

  output: {
    filename: 'bundle.js',
    path: path.resolve(__dirname, 'public'),
    publicPath: '/',
  },

  plugins: [
    new MiniCssExtractPlugin(),

    //////
    // copy-webpack-plugin
    // https://github.com/webpack-contrib/copy-webpack-plugin
    //////
    // new CopyWebpackPlugin([{
    //   from: '/path/to/src',
    //   to: '/path/to/dest'
    // }]),
    new CopyWebpackPlugin({
        patterns: [
            {
                from: './node_modules/jquery/dist/jquery.min.js',
                to: 'jquery.min.js'
            },
            {
                from: './src/stuff.js',
                to: 'stuff.js'
            },
            {
                from: './src/images/goosehouse_goods.jpg',
                to: 'images/goosehouse_goods.jpg'
            }
        ],
    }),

    new webpack.ProvidePlugin({
        $: 'jquery',
        jQuery: 'jquery',
        'window.jQuery': 'jquery'
    }),
    new webpack.DefinePlugin({
      'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV)
    })
  ],

  devServer: {
    contentBase: path.join(__dirname, 'public'),
    port: 3000,
    inline: true
  },

  module: {
    rules: [
      {
        test: /\.(woff2?|ttf|eot|svg)$/,
        type: 'asset/resource',
        generator: {
          filename: 'fonts/[name][ext]'
        }
      },
      {
        test: /\.scss$/,
        use: [
          'style-loader',
          {
            loader: 'css-loader',
            options: {
              url: false,
              importLoaders: 2
            },
          },
          {
            loader: 'sass-loader',
          }
        ],
      },
      {
        test: /\.css$/i,
        use: [MiniCssExtractPlugin.loader, "css-loader"],
      },
      {
        test: /\.less$/,
        use: ['style-loader', 'css-loader', 'less-loader'],
      },
      {
        test: /\.(jpg|png)$/,
        use: 'url-loader'
      },
      {
        test: /\.(js|jsx)$/,
        exclude: /node_modules/,
        use: ['babel-loader']
      }
    ]
  },

  resolve: {
    extensions: ['.js', '.jsx'],
  },

};
