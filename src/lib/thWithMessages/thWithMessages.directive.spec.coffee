{
  compileDirective
} = require "spec_helpers"
testHelpers = require './validationTests.spec'
context = describe

describe 'withMessages', ->
  element = scope = messageEl = template = triggerElement = null

  beforeEach angular.mock.module "ThemisComponents"

  context "with-th-input", ->
    context "using default messages", ->

      testHelpers.testValidationTypes(
        name: "input"
        compileElementFn: testHelpers.setUpElements("input")
        validationTypes: ["required", "maxlength", "minlength", "pattern"]
        messages: testHelpers.defaultMessages()
      )

    context "using custom messages", ->
      scopeAdditions =
        messages:
          required: "requiredMsg"
          minlength: "minlengthMsg"
          maxlength: "maxlengthMsg"
          pattern: "patternMsg"

      testHelpers.testValidationTypes(
        name: "input"
        compileElementFn: testHelpers.setUpElements("input", scopeAdditions)
        validationTypes: ["required", "maxlength", "minlength", "pattern"]
        messages: scopeAdditions.messages
      )

      testHelpers.testWithValidInput(
        "input", testHelpers.setUpElements("input")
      )

    context "with type='number'", ->
      context "with only one number validator", ->
        context "using default messages", ->

          beforeEach ->
            template = (min, max) ->
              minAttr = -> if min != "" then "min=#{min}" else ""
              maxAttr = -> if max != "" then "max=#{max}" else ""
              """<form name="form">
                <th-input
                  with-messages
                  name="inputName"
                  ng-model="modelName"
                  #{maxAttr()}
                  #{minAttr()}
                  type="number"
                  >
                </th-input>
              </form>"""
            triggerElement = ->
              element.find("input").triggerHandler 'focus'
              element.find("input").triggerHandler 'blur'

          it "sets the form to invalid", ->
            {element, scope} = compileDirective(template("", "10"), {modelName: 20})
            triggerElement()
            expect(scope.form.$invalid).toBe true

          it "display the default 'min' message", ->
            {element, scope} = compileDirective(template("", "10"), {modelName: 20})
            triggerElement()
            normalized = element.find(".message-text").text().trim()
            expect("Please enter a valid number less than or equal to 10.").toBe normalized

      context "using both number validators", ->
        context "using default messages", ->
          it "sets the form to invalid", ->
            {element, scope} = compileDirective(template("1", "10"), {modelName: 20})
            triggerElement()
            expect(scope.form.$invalid).toBe true

            scope.modelName = 0.5
            triggerElement()
            expect(scope.form.$invalid).toBe true

          it "set the 'min' and 'max' messages to the range message", ->
            {element, scope} = compileDirective(template("1", "10"), {modelName: 20})
            triggerElement()
            normalized = element.find(".message-text").text().trim()
            expect("Please enter a number between 1 and 10.").toBe normalized

            scope.modelName = 0.5
            triggerElement()
            normalized = element.find(".message-text").text().trim()
            expect("Please enter a number between 1 and 10.").toBe normalized

  context "with-th-textarea", ->
    context "using default messages", ->

      testHelpers.testValidationTypes(
        name: "textarea"
        compileElementFn: testHelpers.setUpElements("textarea")
        validationTypes: ["required", "maxlength", "minlength", "pattern"]
        messages: testHelpers.defaultMessages()
      )

    context "using custom messages", ->
      scopeAdditions =
        messages:
          required: "requiredMsg"
          minlength: "minlengthMsg"
          maxlength: "maxlengthMsg"
          pattern: "patternMsg"

      testHelpers.testValidationTypes(
        name: "textarea"
        compileElementFn: testHelpers.setUpElements("textarea", scopeAdditions)
        validationTypes: ["required", "maxlength", "minlength", "pattern"]
        messages: scopeAdditions.messages
      )

      testHelpers.testWithValidInput(
        "textarea", testHelpers.setUpElements("textarea")
      )

  context "with-th-select", ->
    context "using default messages", ->

      testHelpers.testValidationTypes(
        name: "select"
        compileElementFn: testHelpers.setUpElements("select")
        validationTypes: ["required"]
        messages: testHelpers.defaultMessages()
      )

    context "using custom messages", ->
      scopeAdditions = {messages: {required: "requiredMsg"}}

      testHelpers.testValidationTypes(
        name: "select"
        compileElementFn: testHelpers.setUpElements("select", scopeAdditions)
        validationTypes: ["required"]
        messages: scopeAdditions.messages
      )

      testHelpers.testWithValidInput(
        "select", testHelpers.setUpElements("select")
      )

  context "with th-switch, th-checkbox, th-radio-group", ->

    beforeEach ->
      template = testHelpers.validTemplate()
      scopeAdditions = messages: {required: "customized"}
      {element, scope} = compileDirective(template, scopeAdditions)

    context "when input is invalid and on submit", ->
      beforeEach ->
        scope.form.$submitted = true
        scope.$apply()

      it "sets the form and element to invalid", ->
        expect(scope.form.$submitted).toBe true
        expect(scope.form.$invalid).toBe true

      ["switch", "checkbox", "radio"].forEach (type) ->
        beforeEach ->
          messageEl = element.find ".th-#{type} + .th-with-message .message-text"
          if type is "radio"
            messageEl = element.find(
              ".th-#{type}-group + .th-with-message .message-text"
            )

        context "when 'th-#{type}' is invalid", ->
          it "sets the #{type} form property to be invalid", ->
            expect(scope.form["#{type}Name"].$error.required).toBe true

          it "sets the displays the error message element", ->
            expect(messageEl.length).toBe 1

          it "displays the custom 'required' error message", ->
            normalized = messageEl.text().trim()
            expect(normalized).toBe "customized"
