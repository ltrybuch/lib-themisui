{
  compileDirective
} = require "spec_helpers"
context = describe

describe 'thTextarea', ->
  element = textarea = timeout = null

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach inject ($timeout) ->
    timeout = $timeout

  beforeEach inject ($timeout) ->
    timeout = $timeout

  context 'with complete example', ->
    beforeEach ->
      {element} = compileDirective("""
        <th-textarea
          name="nickname"
          rows="5"
          placeholder="Enter your nickname">
        </th-textarea>
      """)
      textarea = element.find("textarea")
    it "removes the icon element when the icon attribute is not specified", ->
      expect(element.find("i").length).toBe 0

    it "gains class 'has-focus' when in focus", ->
      textarea.triggerHandler 'focus'
      expect(textarea.hasClass("has-focus")).toBe true

    it "loses class 'has-focus' when blurred", ->
      textarea.triggerHandler 'focus'
      expect(textarea.hasClass("has-focus")).toBe true
      textarea.triggerHandler 'blur'
      expect(textarea.hasClass("has-focus")).toBe false

    describe 'textarea', ->
      it 'has appropriate attributes set', ->
        textarea = element.find("textarea").first()

        expect(textarea.attr("rows")).toBe '5'
        expect(textarea.attr("name")).toBe 'nickname'
        expect(textarea.attr("placeholder")).toBe 'Enter your nickname'

  context "with expandable set to false", ->
    beforeEach ->
      {element} = compileDirective(
        """<th-textarea expandable="false"></th-textarea>""")
    it "disables resizing", ->
      expect(element.find("textarea").css("resize")).toEqual "none"

  context "with icon", ->
    beforeEach ->
      {element} = compileDirective(
        """<th-textarea icon="dollar"></th-textarea>""")

    it "adds an icon with the specified icon class", ->
      expect(element.find("i").hasClass("fa-dollar")).toBeTruthy()

    it "adds with-icon to the input field", ->
      expect(element.find("textarea").hasClass("with-icon")).toBeTruthy()

  context "with ng-change attr", ->
    beforeEach ->
      scopeAdditions = {}
      scopeAdditions.onChange = -> alert "changed"
      {element} = compileDirective(
        """<th-textarea ng-change="onChange()" ng-model="text"></th-textarea>""",
        scopeAdditions
      )

    it "On change the ngChange function is called", ->
      spyOn window, 'alert'
      element.find('textarea').triggerHandler 'change'
      timeout.flush()
      expect(window.alert).toHaveBeenCalledWith 'changed'

  context "with validations", ->
    beforeEach ->
      scopeAdditions =
        pattern: /^[a-zA-Z ]*$/
      {element} = compileDirective("""
        <th-textarea
          ng-required="true"
          ng-minLength="10"
          ng-maxLength="20"
          ng-pattern="pattern">
        </th-textarea>""", scopeAdditions)

    describe "textarea", ->
      it "has all ng-requirements added", ->
        textarea = element.find("textarea")[0]
        expect(textarea.hasAttribute("ng-required")).toBe true
        expect(textarea.hasAttribute("required")).toBe true
        expect(textarea.hasAttribute("ng-minLength")).toBe true
        expect(textarea.hasAttribute("ng-maxLength")).toBe true
        expect(textarea.hasAttribute("ng-pattern")).toBe true
        expect(textarea.getAttribute("ng-pattern")).toEqual '/^[a-zA-Z ]*$/'
        expect(textarea.getAttribute("ng-minLength")).toEqual '10'
        expect(textarea.getAttribute("ng-maxLength")).toEqual '20'

    context "with ng-disabled evaluating to true", ->
      beforeEach ->
        {element} = compileDirective(
          """<th-textarea ng-disabled="true"></th-textarea>""")

      describe "the textarea", ->
        it "is disabled", ->
          expect(element.find("textarea").attr("disabled")).toEqual "disabled"
          expect(element.find("textarea").hasClass("disabled")).toBe true
