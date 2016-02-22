context = describe
sharedTests = require './sharedTests'

describe 'withLabel', ->
  element = null

  compileElement = ->
    scopeAdditions =
      onChange: -> alert "Alerting!"
      model: false
    compileDirective("""
      <th-switch
        with-label="label name"
        ng-model="model"
        ng-change="onChange()"
        >
      </th-switch>
    """, scopeAdditions)

  context "with th-switch", ->
    sharedTests.testingInlineLabel compileElement

    context "when clicking label with an ng-change attribute", ->
      sharedTests.testingNgChange compileElement
