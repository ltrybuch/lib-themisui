gulp = require 'gulp'

browserify = require 'browserify'
watchify = require 'watchify'
source = require 'vinyl-source-stream'
derequire = require 'gulp-derequire'
stringify = require 'stringify'
templates = stringify ['html']

isWatching = no

docsFiles = [
  {
    input: ['./public/javascript/examples.coffee']
    output: 'examples-app.js'
    extensions: ['.coffee', '.html']
    transform: [templates]
    destination: './public/build/'
  }
  {
    input: ['./public/javascript/docs.coffee']
    output: 'docs-app.js'
    extensions: ['.coffee', '.html']
    transform: [templates]
    destination: './public/build/'
  }
]

libraryFiles = [
  {
    input: ['./themis_components/index.coffee']
    output: 'lib-themisui.js'
    extensions: ['.coffee', '.html']
    transform: [templates]
    destination: './public/build/'
    standalone: 'lib-ThemisUI'
  }
]

createBundle = (options) ->
  browserifyOptions =
    cache: {}
    packageCache: {}
    entries: options.input
    transform: options.transform
    extensions: options.extensions

  if options.standalone?
    browserifyOptions.standalone = options.standalone

  bundler = browserify browserifyOptions

  rebundle = ->
    startTime = new Date().getTime()

    bundler
      .bundle()
      .on 'error', -> console.log arguments
      .pipe source(options.output)
      .pipe derequire()
      .pipe gulp.dest(options.destination)
      .on 'end', ->
        time = (new Date().getTime() - startTime) / 1000
        console.log "#{options.output} was browserified: #{time}s"

  if isWatching
    bundler = watchify bundler
    bundler.on 'update', rebundle

  rebundle()

createBundles = (bundles) ->
  bundles.forEach (bundle) -> createBundle bundle

gulp.task 'docs-browserify', ->
  createBundles docsFiles

gulp.task 'lib-themisui', ->
  createBundles libraryFiles

gulp.task 'docs-watchify', ['docs-browserify-setWatch', 'docs-browserify']

gulp.task 'docs-browserify-setWatch', ->
  isWatching = yes
