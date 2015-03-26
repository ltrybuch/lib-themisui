ddescribe 'ThemisComponent: Directive: thSwitch', ->
  element = scope = compile = defaultState = null
  validTemplate = """<th-switch ng-model="state"></th-switch>"""

  createDirective = (state, template) ->
    scope.state = state ? defaultState

    element = compile(template ? validTemplate)(scope)
    debugger
    scope.$apply()

    return element

  beforeEach ->
    defaultState = off

    inject ($rootScope, $compile) ->
      scope = $rootScope.$new()
      compile = $compile

  it 'should have an interrupter', ->
    element = createDirective()
    expect(element.find('i').length).toBe 1

  it 'should toggle to on', ->
    element = createDirective()
    element.click()
    expect(element.hasClass('active')).toBe true
    expect(scope.state).toBe on

  it 'should toggle to off', ->
    element = createDirective(on)
    element.click()
    expect(element.hasClass('active')).toBe false
    expect(scope.state).toBe off

  it 'should toggle to on and off again', ->
    element = createDirective()
    element.click()
    element.click()
    expect(element.hasClass('active')).toBe false
    expect(scope.state).toBe off

