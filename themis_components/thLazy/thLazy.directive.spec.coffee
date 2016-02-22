context = describe

describe 'ThemisComponents: Directive: thLazy', ->
  element = httpBackend = scope = compile = null
  mockResponse = "<h1>Popover</h1>"
  validTemplate = '<div th-lazy src="/template.html"></div>'

  compileDirective = (template) ->
    template = template ? validTemplate

    element = compile(template)(scope)

    scope.$digest()
    return element

  beforeEach ->
    angular.mock.module 'ThemisComponents'

  beforeEach inject ($injector) ->
    httpBackend = $injector.get '$httpBackend'
    scope = $injector.get('$rootScope').$new()
    compile = $injector.get '$compile'

  context "with a valid template path", ->
    beforeEach ->
      httpBackend.when('GET', '/template.html').respond mockResponse

    beforeEach ->
      element = compileDirective()

    it 'should have a loading indicator', ->
      expect(element.find('div').hasClass("th-loader")).toBe true

    it 'should request template', ->
      httpBackend.flush()
      httpBackend.expectGET '/template.html'

  context "with a broken template with custom error message", ->
    beforeEach ->
      httpBackend.when('GET', '/brokenPath.html').respond 404, ''
      element = compileDirective(
        '<div th-lazy src="/brokenPath.html" error-message="mmm nope"></div>'
      )
      httpBackend.flush()

    it "displays the custom error message", ->
      expect(element.find("ng-transclude > span").text()).toMatch "mmm nope"

    it "hides the loader component", ->
      expect(element.find(".th-loader").hasClass("ng-hide")).toBe true

  context "with a broken template and no error message", ->
    beforeEach ->
      httpBackend.when('GET', '/brokenPath.html').respond 404, ''
      element = compileDirective(
        '<div th-lazy src="/brokenPath.html"></div>'
      )
      httpBackend.flush()

    it "shows the default error message", ->
      expect(element.find("span").text()).toMatch(
        "We had trouble loading your content.Try reloading the page."
      )

    it "hides the loader component", ->
      expect(element.find(".th-loader").hasClass("ng-hide")).toBe true
