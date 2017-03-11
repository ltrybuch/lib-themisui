const ExtractTextPlugin = require("extract-text-webpack-plugin");
const bourbon = require("node-bourbon").includePaths;
const sassIncludePaths = [
  "includePaths[]=engines/titan/app/assets/stylesheets&",
  "includePaths[]=vendor/assets/stylesheets&",
  "includePaths[]=" + bourbon
];

module.exports = function(env={}) {
  const loaders = [
    {
      test: /\.coffee$/,
      loader: "ng-annotate-loader!coffee-loader"
    },
    {
      test: /\.ts$/,
      loader: "ng-annotate-loader!ts-loader!tslint-loader"
    },
    {
      test: /\.json$/,
      loader: "json-loader"
    },
    {
      test: /\.template\.html$/,
      loader: "raw-loader"
    },
    {
      test: /\.scss$/,
      loader: ExtractTextPlugin.extract("css-loader!postcss-loader!sass-loader?sourceMap&" + sassIncludePaths.join(""))
    },
    {
      test: /\.(png|jpg|jpeg|gif)$/,
      exclude: /node_modules/,
      loader: "url-loader",
      query: {
        name: "images/[name].[ext]",
        limit: 20000 // => DataUrl if "file.png" is smaller than 10kb
      }
    },
    {
      test: /\.svg$/,
      loader: "svg-url-loader"
    },
    {
      test: /\.md$/,
      exclude: /node_modules/,
      loader: "raw-loader"
    },
    {
      test: /\.ttf|\.eot|\.woff$/,
      exclude: /node_modules/,
      loader: "file-loader",
      query: {
        name: "fonts/[name].[ext]"
      }
    }
  ];

  //-- karma coverage
  if(env.coverage) {
    loaders.push({
      test: env.sourcesRegex,
      enforce: "post",
      loader: "istanbul-instrumenter-loader",
      exclude: [
        /\.spec\.(ts|coffee)$/,
        /(T|t)ests\.(ts|coffee)$/,
        /node_modules/,
        /polyfills/,
        /public/,
        /spec_modules/
      ]
    });
  }

  return loaders;
};
