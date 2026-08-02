var webpack = require('webpack');
var path = require('path');

var src_path = path.resolve('./src');
var dist_path = path.resolve('./dist');
var isDevServer = process.argv.some(function(arg) {
    return arg.indexOf('webpack-dev-server') !== -1;
});

var entry = [
    'babel-polyfill', './polyfills/browser-crypto.js', './index.js'
];

var plugins = [
    new webpack.ProvidePlugin({$: 'jquery', jQuery: 'jquery'}),
];

if (isDevServer) {
    entry.unshift('webpack-dev-server/client?http://0.0.0.0:8080', 'webpack/hot/only-dev-server');
    plugins.push(new webpack.HotModuleReplacementPlugin());
}

module.exports = {
    context: src_path,
    entry: entry,
    output: {
        path: dist_path,
        filename: 'index.js'
    },
    module: {
        loaders: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                loader: 'babel-loader',
                query: {
                    presets: ['react'],
                    plugins: ['transform-es2015-destructuring', 'transform-es2015-parameters', 'transform-object-rest-spread', 'transform-es2015-modules-commonjs', 'react-hot-loader/babel']
                }
            }, {
                test: /\.css$/,
                loader: 'style-loader!css-loader'
            }, {
                test: /\.png$/,
                loader: 'url-loader?limit=100000'
            }, {
                test: /\.jpg$/,
                loader: 'file-loader'
            }, {
                test: /\.(woff|woff2)(\?v=\d+\.\d+\.\d+)?$/,
                loader: 'url-loader?limit=10000&mimetype=application/font-woff'
            }, {
                test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/,
                loader: 'url-loader?limit=10000&mimetype=application/octet-stream'
            }, {
                test: /\.eot(\?v=\d+\.\d+\.\d+)?$/,
                loader: 'file-loader'
            }, {
                test: /\.svg(\?v=\d+\.\d+\.\d+)?$/,
                loader: 'url-loader?limit=10000&mimetype=image/svg+xml'
            }, {
                test: /\.json$/,
                loader: 'json-loader'
            }, {
                test: /\.swf$/,
                loader: "file-loader?name=[path][name].[ext]"
            }, {
                test: require.resolve('snapsvg'),
                loader: 'imports-loader?this=>window,fix=>module.exports=0'
            },
        ]
    },
    plugins: plugins,
    devServer: {
        contentBase: dist_path,
        inline: false,
        hot: true,
        host: '0.0.0.0'
    },
    devtool: 'source-map'
};
