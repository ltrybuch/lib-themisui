gulp = require "gulp"
gutil = require "gulp-util"
webpack = require "webpack"

wpConfig = require("../../webpack/webpack.config.js") cache: true, dev: true

devCompiler = webpack wpConfig

gulp.task "docs-webpack", (cb) ->
  devCompiler.run (err, stats) ->

    if stats.compilation.errors and stats.compilation.errors.length
      console.log "Webpack Error", stats.compilation.errors[0].name

    if err
      throw new gutil.PluginError "webpack", err

    gutil.log "[webpack:dev]", stats.toString(chunks: false, colors: true)
    cb()
