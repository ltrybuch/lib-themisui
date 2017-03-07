{
  compileDirective
} = require "spec_helpers"
sharedTests = require './sharedTests'
context = describe

describe 'withSubtext', ->
  element = null

  beforeEach angular.mock.module "ThemisComponents"

  context "with th-input", ->
    createThInput = ->
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

    it "adds subtext class to container", ->
      {element} = createThInput()
      expect(element.is("span.with-subtext")).toBe true

    sharedTests.testingBlockSubLabel createThInput, "label subtext"

  context "with th-select", ->
    createThSelect = ->
      additions = {change: -> alert "Alerting!"}
      compileDirective("""
        <th-select
          with-label="label name"
          with-subtext="These are some options"
          ng-model="model"
          ng-change="change()"
          >
        <option value="4">Corporate</option>
        <option value="5">Criminal</option>
        </th-select>
      """, additions)


    it "adds subtext class to container", ->
      {element} = createThSelect()
      expect(element.is("div.with-subtext")).toBe true

    sharedTests.testingBlockSubLabel createThSelect, "These are some options"
