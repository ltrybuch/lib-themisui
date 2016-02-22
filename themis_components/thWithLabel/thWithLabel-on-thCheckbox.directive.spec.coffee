context = describe
sharedTests = require './sharedTests'

describe 'withLabel', ->
  element = null

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
