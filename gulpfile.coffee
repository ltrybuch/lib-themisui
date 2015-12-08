require('es6-promise').polyfill()
gulp = require 'gulp'
path = require 'path'
sass = require 'gulp-sass'
rename = require 'gulp-rename'
coffeelint = require 'gulp-coffeelint'

gulp.task 'default', ->
  console.log """
    ####################

    Welcome to ThemisUI

    To run the documention viewer do:
      gulp docs

    ####################
  """

###
# ThemisUI Docs
###

gulp.task 'docs', ['docs-server', 'docs-watch']

# creates gulp.task 'docs-server' and 'docs-restart'
require('./gulp/tasks/docsServer')

# creates gulp.task 'docs-browserify'
# creates gulp.task 'docs-watchify'
require './gulp/tasks/docsBrowserify'

gulp.task 'docs-style', ->
  console.log "app.css is building"

  gulp
    .src path.join('public', 'stylesheets', 'index.scss')
    .pipe sass(includePaths: require('node-bourbon').includePaths)
    .pipe rename('app.css')
    .pipe gulp.dest path.join('public', 'build')

gulp.task 'docs-examples-style', ->
  console.log "examples.css is building"

  gulp
    .src path.join('themis_components', 'examples.scss')
    .pipe sass(includePaths: require('node-bourbon').includePaths)
    .pipe rename('examples.css')
    .pipe gulp.dest path.join('public', 'build')

gulp.task 'docs-lint', ->
  gulp
    .src ['./themis_components/**/*.coffee', './public/javascript/**/*.coffee']
    .pipe coffeelint()
    .pipe coffeelint.reporter()

gulp.task 'docs-watch', ['docs-watchify', 'docs-style', 'docs-examples-style', 'docs-lint'], ->
  gulp.watch ['public/javascript/**/*.coffee', 'themis_components/**/*.coffee'], ['docs-lint']
  gulp.watch 'themis_components/**/*.scss', ['docs-style', 'docs-examples-style']
  gulp.watch 'public/**/*.scss', ['docs-style']

