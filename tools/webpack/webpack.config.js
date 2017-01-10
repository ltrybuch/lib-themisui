const path = require("path");
const webpack = require("webpack");

module.exports = function(env={}) {

  const root = path.resolve(__dirname, "../../");
  const rootSrc = path.join(root, "src");
  const sourcePath = path.join(rootSrc, "src", "lib");
  const distRoot = path.join(root, "dist");
  const publicAssetsRoot = path.join(root, ".tmp/assets");
  const docsAppRoot = path.join(rootSrc, "docs-app", "javascript");
  const sourcesRegex = /\.(ts|coffee)($|\?)/i;

  env.distRoot = distRoot;
  env.publicAssetsRoot = publicAssetsRoot;
  env.root = root;
  env.sourcesRegex = sourcesRegex;

  const loaders = require("./webpack.loaders")(env);
  const plugins = require("./webpack.plugins")(env);

  // App entries
  const entry = {
    "lib-themisui": path.join(rootSrc, "lib", "index.coffee"),
    "lib-themisui-styles": path.join(rootSrc, "lib", "index.scss")
  };

  if(!env.dist) {
    entry["examples"] = path.join(docsAppRoot, "examples.coffee");
    entry["docs-app"] = path.join(docsAppRoot, "docs-app.module.coffee");
  }

  entry["docs-vendor"] = [
    "angular",
    "angular-animate",
    "angular-aria",
    "angular-datepicker",
    "angular-messages",
    "angular-sanitize",
    "debounce",
    "events",
    "jquery",
    "./src/polyfills/index.coffee",
    "keycode",
    "marked",
    "moment",
    "pluralize",
    "qs",
    "ui-select",
    "uuid"
  ];

  // if we are in dev mode, pull ThemisUI into docs-vendor
  // to reduce dev bundle size
  if(!env.dist) {
    entry["docs-vendor"].push('./src/lib/index.coffee');
  }

  // Externals
  let externals = {};

  if(env.dist) {
    externals = {
      "angular": "angular",
      "angular-animate": "angular-animate",
      "angular-sanitize": "angular-sanitize",
      "qs": "qs",
      "ui-select": "ui-select",
      "uuid": "uuid"
    }
  }

  // Output
  const output = {
    path: env.dist ? distRoot : publicAssetsRoot,
    pathinfo: env.dist,
    publicPath: "/",
    filename: "[name].js",
    sourceMapFilename: "debugging/[file].map"
  };

  if(env.dist) {
    output.libraryTarget = "commonjs2";
    output.library = "lib-ThemisUI";
  }

  const devtool = env.dist ? "source-map" : "cheap-module-eval-source-map";
  const extensions = [".js", ".coffee", ".ts", ".json", ".md"];
  const resolveModules = [
    sourcePath,
    "node_modules"
  ];

  if(env.test) {
    resolveModules.push(path.join(root, "test", "spec_modules"));
  }

  // return valid webpack config
  return {
    cache: env.cache,
    watch: env.watch,
    entry,
    externals,
    output,
    module: {
      rules: loaders
    },
    devtool,
    resolve: {
      extensions,
      modules: resolveModules
    },
    performance: {
      hints: env.dist ? true : false
    },
    plugins
  };
};
