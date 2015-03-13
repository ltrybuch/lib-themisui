gulp = require 'gulp'
glob = require 'glob'
path = require 'path'
fs = require 'fs'

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

gulp.task 'docs', ['docs-server'], ->

gulp.task 'docs-server', ->
  connect = require 'connect'
  serveStatic = require 'serve-static'

  http = require 'http'

  port = 3042
  hostname = null # allow to connect from anywhere
  docsDir = path.resolve path.join '.', 'docs'

  app = connect()
    .use serveStatic docsDir

  http.createServer(app).listen port, hostname

  console.log """
    ####################

    Running ThemisUI Docs on port #{port}.
      http://localhost:#{port}

    ####################
  """

componentDirectories = ->
  glob.sync path.join('.', 'themis_components', '!(theme)', '/')

gulp.task 'docs-build-componentsList', ->
  componentList = ( path.basename(item) for item in componentDirectories() )

  fs.writeFile path.join('.', 'docs', 'build', 'components.json'), JSON.stringify(componentList)

