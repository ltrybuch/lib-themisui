describe 'ThemisComponents: Directive: thButton', ->
  element = compile = scope = null

  validTemplate    = '<div th-button ng-click="action()">some text</div>'
  disabledTemplate = '<div th-button ng-click="action()" disabled>some text</div>'
  submitTemplate   = '<div th-button type="submit" text="submit text"></div>'

  compileDirective = (template) ->
    element = compile(template)(scope)
    scope.$digest()
    return element

  beforeEach ->
    module 'ThemisComponents'

  beforeEach ->
    inject ($rootScope, $compile) ->
      scope = $rootScope.$new()
      scope.text = 'correct'
      compile = $compile

  beforeEach ->
    element = compileDirective(validTemplate)

  it 'has the button text set correctly', ->
    expect(element.text().trim()).toBe 'some text'

  it 'has type "button"', ->
    expect(element.attr('type')).toBe 'button'

  it 'creates the correct DOM element', ->
    buttonElement = element.find('button')
    expect(buttonElement).toBeDefined()

  it 'replaces the directive element', ->
    expect(element.find('th-button').length).toEqual 0

  describe 'and the button is disabled', ->
    beforeEach ->
      element = compileDirective(disabledTemplate)

    it 'has the disabled attribute', ->
      expect(element[0].hasAttribute('disabled')).toBe true

  describe 'is a submit button', ->
    beforeEach ->
      element = compileDirective(submitTemplate)

    it 'has type of submit', ->
      expect(element.attr('type')).toBe 'submit'
