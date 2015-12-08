describe 'ThemisComponents: Directive: thCheckbox', ->
  element = scope = compile = defaultState = null
  validTemplate = '<div th-checkbox ng-model="checked" ng-change="callback()"></div>'

  beforeEach ->
    module 'ThemisComponents'

  compileCheckboxDirective = (template, checked, callback) ->
    scopeAdditions =
      checked: checked
      callback: callback

    directive = compileDirective(template, scopeAdditions)
    element = directive.element
    scope = directive.scope

  describe 'when checkbox is unchecked', ->
    beforeEach ->
      compileCheckboxDirective(validTemplate)

    it 'should have an indicator', ->
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
