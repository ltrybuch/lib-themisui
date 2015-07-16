describe 'ThemisComponents: Directive: thCheckbox', ->
  element = scope = compile = defaultState = null
  validTemplate = '<div th-checkbox ng-model="checked"></div>'

  compileDirective = (checked, template) ->
    scope.checked = checked ? defaultState
    template = template ? validTemplate

    element = compile(template)(scope)

    scope.$digest()

    return element

  beforeEach ->
    module 'ThemisComponents'

  beforeEach ->
    defaultState = false

    inject ($rootScope, $compile) ->
      scope = $rootScope.$new()
      compile = $compile

  beforeEach ->
    element = compileDirective()

  it 'should have an i element', ->
    expect(element.find('i').length).toBe 1

  it 'should toggle to checked', ->
    element.triggerHandler 'click'
    expect(element.hasClass('checked')).toBe true
    expect(scope.checked).toBe true

  it 'should toggle to unchecked', ->
    element = compileDirective(true)
    element.triggerHandler 'click'
    expect(element.hasClass('checked')).toBe false
    expect(scope.checked).toBe false

  it 'should toggle to checked and unchecked again', ->
    element.triggerHandler 'click'
    element.triggerHandler 'click'
    expect(element.hasClass('checked')).toBe false
    expect(scope.checked).toBe false

