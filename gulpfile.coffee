gulp = require 'gulp'
path = require 'path'

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

require './gulp/tasks/docsServer'

gulp.task 'docs-watch', ->
  # gulp.watch path.join('themis_components', '*'), ['docs-build-componentsList']

