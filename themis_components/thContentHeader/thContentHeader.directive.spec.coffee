describe 'ThemisComponents: Directive: thContentHeader', ->
  
  element = scope = null
  template = """
    <div th-content-header title="Page Title">
      <button name="thing"></button>
    </div>
  """
  
  beforeEach ->
    module 'ThemisComponents'

  beforeEach ->
    inject ($rootScope, $compile) ->
      scope = $rootScope.$new()
      element = $compile(template) scope
      scope.$digest()

  it "has a title", ->
    expect(element.children("h1").hasClass("th-header-title")).toEqual(true)
    expect(element.children("h1").text()).toEqual("Page Title")

  it "transcludes the elements contained within it", ->
    expect(element.children("ng-transclude").children().length).toEqual(1)
