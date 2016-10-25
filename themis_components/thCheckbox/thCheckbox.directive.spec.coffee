{
  compileDirective
} = require "spec_helpers"

describe 'ThemisComponents: Directive: thCheckbox', ->
  element = scope = compile = defaultState = null
  validTemplate = """<div th-checkbox ng-model="checked" ng-change="callback()"></div>"""
  disabledTemplate = """
    <div ng-disabled="true" th-checkbox ng-model="checked" ng-change="callback()"></div>
  """
  indeterminateTemplate = """
    <div th-checkbox ng-model="checked" indeterminate="indeterminate"></div>
  """

  beforeEach angular.mock.module 'ThemisComponents'

  compileCheckboxDirective = (template, checked, callback, indeterminate) ->
    scopeAdditions = {checked, callback}
    scopeAdditions.indeterminate = indeterminate if indeterminate

    directive = compileDirective(template, scopeAdditions)
    element = directive.element
    scope = directive.scope

  describe 'when checkbox is unchecked', ->
    beforeEach ->
      compileCheckboxDirective(validTemplate)

    it 'should toggle to checked', ->
      element.triggerHandler 'click'
      expect(element.hasClass('checked')).toBe true
      expect(scope.checked).toBe true

    it 'should toggle to checked and unchecked again', ->
      element.triggerHandler 'click'
      element.triggerHandler 'click'
      expect(element.hasClass('checked')).toBe false
      expect(scope.checked).toBe false

  describe 'when checkbox is checked', ->
    beforeEach ->
      compileCheckboxDirective(validTemplate, true)

    it 'should toggle to unchecked', ->
      element.triggerHandler 'click'
      expect(element.hasClass('checked')).toBe false
      expect(scope.checked).toBe false

  describe 'when template specifies callback', ->
    beforeEach ->
      compileCheckboxDirective(
        validTemplate,
        false,
        ->
          return
        )

    it 'should trigger callback', ->
      spyOn scope, 'callback'
      element.triggerHandler 'click'
      expect(scope.callback).toHaveBeenCalled()

  describe "when the indeterminate state is triggered",  ->
    beforeEach ->
      compileCheckboxDirective indeterminateTemplate, false, (-> return), false

    it "toggles indeterminate icon", ->
      scope.$apply -> scope.indeterminate = yes
      expect(element.hasClass("indeterminate")).toBe true

      scope.$apply -> scope.indeterminate = no
      expect(element.hasClass("indeterminate")).toBe false

  describe "when indeterminate state is active and thCheckbox is clicked", ->
    beforeEach ->
      compileCheckboxDirective indeterminateTemplate, false, (-> return), true
      element.triggerHandler "click"

    it "the 'checked' icon is visible", ->
      expect(element.hasClass("checked")).toBe true

    it "the 'indeterminate' icon is hidden", ->
      expect(element.hasClass("indeterminate")).toBe false

    it "sets indeterminate state to false", ->
      expect(scope.indeterminate).toBe false

  describe "when thCheckbox is selected and indeterminate is set to true", ->
    beforeEach ->
      compileCheckboxDirective indeterminateTemplate, true, (-> return)
      scope.$apply -> scope.indeterminate = true

    it "sets indeterminate icon to visible", ->
      expect(element.hasClass("indeterminate")).toBe true

    it "the 'checked' icon is hidden", ->
      expect(element.hasClass("checked")).toBe false

    it "the checkbox value keeps original value", ->
      expect(element.find("input").is(":checked")).toBe true

    describe "when thCheckbox is checked again", ->
      beforeEach ->
        element.triggerHandler "click"

      it "sets 'checked' icon to visible", ->
        expect(element.hasClass("checked")).toBe false

      it "sets 'indeterminate' icon to be hidden", ->
        expect(element.hasClass("indeterminate")).toBe false

      it "toggles indeterminate state", ->
        expect(scope.indeterminate).toBe false

      it "toggles checkbox's value", ->
        expect(element.find("input").is(":checked")).toBe false

  describe "when checkbox is disabled", ->
    beforeEach ->
      compileCheckboxDirective disabledTemplate, false

    it "adds the 'disabled' class" , ->
      expect(element.hasClass("disabled")).toBe true

    it "th-checkbox should be disabled", ->
      element.triggerHandler "click"
      expect(scope.checked).toBe false
