context = describe

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
    require('./sharedTests').testingInlineLabel compileElement

    context "when clicking label with an ng-change attribute", ->
      require('./sharedTests').testingNgChange compileElement
