context = describe

describe 'withLabel', ->
  element = null

  compileElement = ->
    additions = {change: -> alert "Alerting!"}
    model = 1
    compileDirective("""
      <th-radio-group ng-model="model" ng-change="change()">
        <th-radio-button with-label="one" value="1"></th-radio-button>
        <th-radio-button with-label="two" value="2"></th-radio-button>
      </th-radio-group>
    """, additions)

  context "with th-radio-group", ->
    beforeEach ->
      {element} = compileElement()

    it "appends inline label instead of prepends label", ->
      expect(element.find("span").hasClass("inline label-text")).toBe true

    it "adds 'with-label' value to label", ->
      expect(element.text()).toMatch "one"

    context "when clicking label with an ng-change attribute", ->
      require('./sharedTests').testingNgChange(compileElement)
