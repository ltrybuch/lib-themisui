describe 'ThemisComponents: Directive: thSwitch', ->
  element = scope = compile = defaultState = null
  validTemplate = '<div th-switch ng-model="state"></div>'

  compileDirective = (state, template) ->
    scope.state = state ? defaultState
    template = template ? validTemplate

    element = compile(template)(scope)

    scope.$digest()

    return element

  beforeEach ->
    module 'ThemisComponents'

  beforeEach ->
    defaultState = off

    inject ($rootScope, $compile) ->
      scope = $rootScope.$new()
      compile = $compile

  beforeEach ->
    element = compileDirective()

  it 'should have an interrupter', ->
    expect(element.find('i').length).toBe 1

  it 'should toggle to on', ->
    element.triggerHandler 'click'
    expect(element.hasClass('active')).toBe true
    expect(scope.state).toBe on

  it 'should toggle to off', ->
    element = compileDirective(on)
    element.triggerHandler 'click'
    expect(element.hasClass('active')).toBe false
    expect(scope.state).toBe off

  it 'should toggle to on and off again', ->
    element.triggerHandler 'click'
    element.triggerHandler 'click'
    expect(element.hasClass('active')).toBe false
    expect(scope.state).toBe off

