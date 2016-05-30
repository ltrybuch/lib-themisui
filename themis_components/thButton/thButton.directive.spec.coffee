context = describe

describe 'ThemisComponents: Directive: thButton', ->
  element = compile = scope = null

  validTemplate    = '<div th-button type="create" ng-click="action()">some text</div>'
  templateWithHref = '<div th-button href="#" type="secondary">some text</div>'
  disabledTemplate = '<div th-button ng-click="action()" disabled>some text</div>'
  submitTemplate   = '<div th-button type="submit" text="submit text"></div>'

  compileDirective = (template) ->
    element = compile(template)(scope)
    scope.$digest()
    return element

  beforeEach angular.mock.module 'ThemisComponents'
  beforeEach inject ($rootScope, $compile) ->
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

  it 'has class "create"', ->
    expect(element.hasClass("create")).toBe true

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

  context 'with href attribute', ->
    beforeEach ->
      element = compileDirective(templateWithHref)

    it 'is an anchor tag', ->
      expect(element[0].tagName).toEqual "A"

    it 'has class "secondary"', ->
      expect(element.hasClass("secondary")).toBe true
