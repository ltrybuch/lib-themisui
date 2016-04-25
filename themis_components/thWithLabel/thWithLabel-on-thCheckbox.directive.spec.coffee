{
  compileDirective
} = require "spec_helpers"
sharedTests = require './sharedTests'
context = describe

describe 'withLabel', ->
  element = null

  beforeEach angular.mock.module "ThemisComponents"

  createElement = ->
    additions = {change: -> alert "Alerting!"}
    compileDirective("""
      <th-checkbox
        with-label="label name"
        ng-model="model"
        ng-change="change()"
        >
      </th-checkbox>
    """, additions)

  context "with th-checkbox", ->
    sharedTests.testingInlineLabel createElement

    context "when clicking label with an ng-change attribute", ->
      sharedTests.testingNgChange createElement
