describe 'ThemisComponents: Directive: thSwitch', ->
  element = httpBackend = scope = compile = null
  mockResponse = "<h1>Popover</h1>"
  validTemplate = '<div th-lazy src="/template.html"></div>'

  compileDirective = (state, template) ->
    template = template ? validTemplate

    element = compile(template)(scope)

    scope.$digest()

    return element

  beforeEach ->
    module 'ThemisComponents'

  beforeEach inject ($injector) ->
    httpBackend = $injector.get '$httpBackend'
    scope = $injector.get('$rootScope').$new()
    compile = $injector.get '$compile'

  beforeEach ->
    httpBackend.when('GET', '/template.html').respond mockResponse

  beforeEach ->
    element = compileDirective()

  it 'should have a loading indicator', ->
    expect(element.find('i').length).toBe 1

  it 'should request template', ->
    httpBackend.expectGET '/template.html'
    httpBackend.flush()

