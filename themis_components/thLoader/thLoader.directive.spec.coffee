describe 'ThemisComponents: Directive: thLoader', ->
  element = scope = text = compile = null
  validTemplate = '<div th-loader loading-text="\'checking...\'"></div>'

  compileDirective = (template) ->
    template = template ? validTemplate
    element = compile(template)(scope)
    scope.$digest()
    return element

  beforeEach ->
    module 'ThemisComponents'

    inject ($rootScope, $compile) ->
      scope = $rootScope.$new()
      compile = $compile

  beforeEach ->
    element = compileDirective()

  it 'should have a class "th-loader"', ->
    expect(element.hasClass('th-loader')).toBe true

  it 'renders the text inside p tag', ->
    expect(element.find("p.loading-text").html()).toBe 'checking...'

  it 'text defaults to "Loading..." with nothing passed in', ->
    template = '<div th-loader></div>'
    element = compileDirective(template)
    expect(element.find("p.loading-text").html()).toBe 'Loading...'