const webpack = require("webpack");
const CleanWebpackPlugin = require("clean-webpack-plugin");
const ExtractTextPlugin = require("extract-text-webpack-plugin");
const StatsPlugin = require("stats-webpack-plugin");

module.exports = function(env={}) {

  const buildPlugins = [];

  if (!env.skipCleanup) {
    buildPlugins.push(new CleanWebpackPlugin([env.dist ? env.distRoot : env.publicAssetsRoot], {
      exclude: ['lib-themisui-apollo-styles.css'],
      root: env.root,
      verbose: true,
      dry: false
    }));
  }

  buildPlugins.push(new webpack.LoaderOptionsPlugin({
    minimize: false,
    debug: !env.dist
  }));

  buildPlugins.push(new webpack.ContextReplacementPlugin(/moment[\/\\]locale$/, /en/));

  if(!env.dist) {
    buildPlugins.push(
      new webpack.optimize.CommonsChunkPlugin({
        name: "docs-vendor",
        minChunks: Infinity,
        filename: "docs-vendor.js"
      })
    );
  }

  const testPlugins = [
    new webpack.ProvidePlugin({
      $: "jquery",
      jQuery: "jquery",
      "window.jQuery": "jquery"
    })
  ];

  const plugins = env.test ? testPlugins : buildPlugins;

  plugins.push(new ExtractTextPlugin("[name].css"));

  if(env.stats) {
    //TODO: Update to include our all of own deps
    var excludeFromStats = [];

    plugins.push(new StatsPlugin("profiling/stats.json", {
      chunkModules: true,
      exclude: excludeFromStats
    }));
  }

  const theme = env.apollo ? "apollo" : "themis";
  plugins.push(
    new webpack.DefinePlugin({
      "process.theme": JSON.stringify(theme)
    })
  );

  if(env.dist) {
    plugins.push(
      new webpack.DefinePlugin({
        "process.env": { NODE_ENV: JSON.stringify("production") }
      })
    );
    plugins.push(new webpack.NoEmitOnErrorsPlugin());
  }

  return plugins;
};
