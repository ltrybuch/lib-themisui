describe 'ThemisComponents: Directive: thSwitch', ->
  element = scope = compile = defaultState = null
  validTemplate = '<div th-switch ng-model="state" ng-change="callback()"></div>'

  beforeEach ->
    module 'ThemisComponents'

  compileSwitchDirective = (template, state, callback) ->
    scopeAdditions =
      state: state ? off
      callback: callback

    directive = compileDirective(template, scopeAdditions)
    element = directive.element
    scope = directive.scope

  describe 'when switch is off', ->
    beforeEach ->
      compileSwitchDirective(validTemplate)

    it 'should have an interrupter', ->
      expect(element.find('i').length).toBe 1

    it 'should toggle to on', ->
      element.triggerHandler 'click'
      expect(element.hasClass('active')).toBe true
      expect(scope.state).toBe on

    it 'should toggle to on and off again', ->
      element.triggerHandler 'click'
      element.triggerHandler 'click'
      expect(element.hasClass('active')).toBe false
      expect(scope.state).toBe off

  describe 'when switch is on', ->
    beforeEach ->
      compileSwitchDirective(validTemplate, on)

    it 'should toggle to off', ->
      element.triggerHandler 'click'
      expect(element.hasClass('active')).toBe false
      expect(scope.state).toBe off

  describe 'when template specifies callback', ->
    beforeEach ->
      compileSwitchDirective(
        validTemplate,
        off,
        () ->
        )

    it 'should trigger callback', ->
      spyOn scope, 'callback'
      element.triggerHandler 'click'
      expect(scope.callback).toHaveBeenCalled()
