gulp = require 'gulp'

browserify = require 'browserify'
watchify = require 'watchify'
source = require 'vinyl-source-stream'

isWatching = no

files = [
  {
    input      : ['./public/javascript/index.coffee']
    output     : 'app.js'
    extensions : ['.coffee']
    transform  : []
    destination: './public/build/'
  }
  {
    input      : ['./index.coffee']
    output     : 'examples.js'
    extensions : ['.coffee']
    transform  : []
    destination: './public/build/'
  }
]

createBundle = (options) ->
  bundler = null

  if options.standalone?
    bundler = browserify
      cache: {}
      packageCache: {}
      fullPaths: true
      entries   : options.input
      transform : options.transform
      extensions: options.extensions
      standalone: options.standalone
  else
    bundler = browserify
      cache: {}
      packageCache: {}
      fullPaths: true
      entries   : options.input
      transform : options.transform
      extensions: options.extensions

  bundler = watchify bundler if isWatching

  rebundle = ->
    startTime = new Date().getTime()
    bundler.bundle()
    .on 'error', ->
      console.log arguments
    .pipe(source(options.output))
    .pipe gulp.dest(options.destination)
    .on 'end', ->
      time = (new Date().getTime() - startTime) / 1000
      console.log "#{options.output} was browserified: #{time}s"

  if isWatching
    bundler.on 'update', rebundle

  rebundle()

createBundles = (bundles) ->
  bundles.forEach (bundle) ->
    createBundle bundle

gulp.task 'docs-browserify', ->
  createBundles files

gulp.task 'docs-watchify', ['docs-browserify-setWatch', 'docs-browserify']

gulp.task 'docs-browserify-setWatch', ->
  isWatching = yes