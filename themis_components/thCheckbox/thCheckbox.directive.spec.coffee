describe 'ThemisComponents: Directive: thCheckbox', ->
  element = scope = compile = defaultState = null
  validTemplate = '<div th-checkbox ng-model="checked" ng-change="changeCallback()"></div>'

  beforeEach ->
    module 'ThemisComponents'

  compileCheckboxDirective = (template, checked, changeCallback) ->
    scopeAdditions =
      checked: checked
      changeCallback: changeCallback

    directive = compileDirective(template, scopeAdditions)
    element = directive.element
    scope = directive.scope

  describe 'when checkbox is unchecked', ->
    beforeEach ->
      compileCheckboxDirective(validTemplate)

    it 'should have an i element', ->
      expect(element.find('i').length).toBe 1

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

  describe 'when template specifies ng-change', ->
    beforeEach ->
      compileCheckboxDirective(
        validTemplate, 
        false, 
        () ->
        )

    it 'should trigger change callback', ->
      spyOn scope, "changeCallback"
      element.triggerHandler 'click'
      expect(scope.changeCallback).toHaveBeenCalled()
