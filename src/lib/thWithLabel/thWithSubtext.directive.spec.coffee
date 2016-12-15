{
  compileDirective
} = require "spec_helpers"
sharedTests = require './sharedTests'
context = describe

describe 'withSubtext', ->
  element = null

  beforeEach angular.mock.module "ThemisComponents"

  createElement = ->
    additions = {change: -> alert "Alerting!"}
    compileDirective("""
      <th-input
        with-label="label name"
        with-subtext="label subtext"
        ng-model="model"
        ng-change="change()"
        >
      </th-input>
    """, additions)

  context "with th-input", ->
    sharedTests.testingBlockSubLabel createElement
    sharedTests.testingBlockSubLabel createElement
