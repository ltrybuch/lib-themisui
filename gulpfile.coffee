require("es6-promise").polyfill()

gulp = require "gulp"
gulpSequence = require "gulp-sequence"
path = require "path"
sass = require "gulp-sass"
rename = require "gulp-rename"
coffeelint = require "gulp-coffeelint"

autoprefixer = require "gulp-autoprefixer"

# creates gulp.task 'docs-server' and 'docs-restart'
require("./tools/gulp/tasks/docsServer")

# creates gulp.task "docs-webpack"
require "./tools/gulp/tasks/docsWebpack"


gulp.task "default", ->
  console.log """
    ####################

    Welcome to ThemisUI

    To run the documention viewer do:
      gulp docs

    ####################
  """


gulp.task "docs", gulpSequence "docs-webpack", "docs-server"
