{
  compileDirective
} = require "spec_helpers"
context = describe

describe 'ThemisComponents: Directive: thButton', ->
  element = compile = scope = null

  validTemplate    = '<div th-button type="create" ng-click="action()">some text</div>'
  templateWithHref = '<div th-button href="#" type="secondary">some text</div>'
  disabledTemplate = '<div th-button ng-click="action()" disabled>some text</div>'
  submitTemplate   = '<div th-button type="submit" text="submit text"></div>'
  loadingTemplate  = """<th-button loading="loading">text</th-button>"""

  beforeEach angular.mock.module 'ThemisComponents'

  beforeEach ->
    {element} = compileDirective(validTemplate)

  it 'the button text is visible by default', ->
    textElement = element.find('ng-transclude')
    expect(textElement.hasClass("show")).toBe true

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
      {element} = compileDirective(disabledTemplate)

    it 'has the disabled attribute', ->
      expect(element[0].hasAttribute('disabled')).toBe true

  describe 'is a submit button', ->
    beforeEach ->
      {element} = compileDirective(submitTemplate)

    it 'has type of submit', ->
      expect(element.attr('type')).toBe 'submit'

  context 'with href attribute', ->
    beforeEach ->
      {element} = compileDirective(templateWithHref)

    it 'is an anchor tag', ->
      expect(element[0].tagName).toEqual "A"

    it 'has class "secondary"', ->
      expect(element.hasClass("secondary")).toBe true

  context 'with loading attribute', ->
    beforeEach ->
      scopeAdditions = {loading: true}
      {element, scope} = compileDirective(loadingTemplate, scopeAdditions)

    context "when loading is true", ->
      it 'should set the loading animation to visible', ->
        loaderElement = element.find(".load-wrapper")
        expect(loaderElement.hasClass("show")).toBe true

        textElement = element.find('ng-transclude')
        expect(textElement.hasClass("hide")).toBe true

    context "when loading is false", ->
      it 'should set the trancluded content to visible', ->

        textElement = element.find('ng-transclude')
        loaderElement = element.find(".load-wrapper")

        expect(loaderElement.hasClass("show")).toBe true
        expect(textElement.hasClass("hide")).toBe true

        scope.$apply -> scope.loading = false

        expect(textElement.hasClass("show")).toBe true
        expect(loaderElement.hasClass("hide")).toBe true
