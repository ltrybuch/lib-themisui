context = describe

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
    require('./sharedTests').testingInlineLabel createElement

    context "when clicking label with an ng-change attribute", ->
      require('./sharedTests').testingNgChange createElement
