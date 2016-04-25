{
  compileDirective
} = require "spec_helpers"
context = describe

describe 'withLabel', ->
  element = null

  beforeEach angular.mock.module "ThemisComponents"

  compileElement = ->
    compileDirective("""<th-input with-label="label name"></th-input>""")

  context 'with th-input example', ->
    require('./sharedTests').testingPrependedLabel compileElement
