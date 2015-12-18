require('es6-promise').polyfill()

gulp = require 'gulp'
path = require 'path'
sass = require 'gulp-sass'
rename = require 'gulp-rename'
coffeelint = require 'gulp-coffeelint'

autoprefixer = require 'gulp-autoprefixer'
autoprefixerOptions =
  browsers: ['last 2 versions', "> 1%", "IE > 9"]
  cascade: false

# creates gulp.task 'docs-server' and 'docs-restart'
require('./gulp/tasks/docsServer')

# creates gulp.task 'docs-browserify' and 'docs-watchify'
require './gulp/tasks/docsBrowserify'


gulp.task 'default', ->
  console.log """
    ####################

    Welcome to ThemisUI

    To run the documention viewer do:
      gulp docs

    ####################
  """


gulp.task 'docs', ['docs-server', 'docs-watch']


gulp.task 'docs-style', ->
  console.log "docs-app.css is building"

  gulp
    .src path.join('public', 'stylesheets', 'docs-app.scss')
    .pipe sass(includePaths: require('node-bourbon').includePaths)
    .pipe autoprefixer autoprefixerOptions

    .pipe rename('docs-app.css')
    .pipe gulp.dest path.join('public', 'build')


gulp.task 'docs-examples-style', ->
  console.log "examples.css is building"

  gulp
    .src path.join('public', 'stylesheets', 'examples.scss')
    .pipe sass(includePaths: require('node-bourbon').includePaths)
    .pipe autoprefixer autoprefixerOptions
    .pipe rename('examples.css')
    .pipe gulp.dest path.join('public', 'build')


gulp.task 'lib-themisui-style', ->
  console.log "lib-themisui.css is building"

  gulp
    .src path.join('themis_components', 'index.scss')
    .pipe sass(includePaths: require('node-bourbon').includePaths)
    .pipe autoprefixer autoprefixerOptions
    .pipe rename('lib-themisui.css')
    .pipe gulp.dest path.join('public', 'build')


gulp.task 'docs-lint', ->
  console.log "Running coffeelint"

  gulp
    .src ['./themis_components/**/*.coffee', './public/javascript/**/*.coffee']
    .pipe coffeelint()
    .pipe coffeelint.reporter()


gulp.task 'docs-watch', ['docs-watchify', 'docs-style', 'docs-examples-style', 'docs-lint'], ->
  gulp.watch ['public/javascript/**/*.coffee', 'themis_components/**/*.coffee'],
             ['docs-lint']
  gulp.watch ['themis_components/**/*.scss', 'public/**/*.scss'],
             ['docs-style', 'docs-examples-style']
