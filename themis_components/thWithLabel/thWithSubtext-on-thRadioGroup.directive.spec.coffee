{
  compileDirective
} = require "spec_helpers"
sharedTests = require './sharedTests'
context = describe

describe 'withSubtext', ->
  element = null

  beforeEach angular.mock.module "ThemisComponents"


  compileElement = ->
    additions = {change: -> alert "Alerting!"}
    model = 1
    compileDirective("""
      <th-radio-group ng-model="model" ng-change="change()">
        <th-radio-button with-label="one" with-subtext="first" value="1"></th-radio-button>
        <th-radio-button with-label="two" with-subtext="second" value="2"></th-radio-button>
      </th-radio-group>
    """, additions)

  context "with th-radio-group", ->
    beforeEach ->
      {element} = compileElement()

    it "appends inline label instead of prepends label", ->
      expect(element.find("span").hasClass("inline label-text")).toBe true

    it "adds subtext element", ->
      expect(element.find("p").hasClass("inline sublabel-text")).toBe true

    it "adds 'with-label' value to label", ->
      expect(element.text()).toMatch "one"

    it "adds 'with-subtext' value to nested sub label", ->
      expect(element.text()).toMatch "first"

    context "when clicking label with an ng-change attribute", ->
      sharedTests.testingNgChange(compileElement)
