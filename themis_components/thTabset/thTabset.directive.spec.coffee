describe 'ThemisComponents: Directive: thTabset', ->
  element = scope = compile = null
  validTemplate = """
    <div th-tabset>
      <div th-tab name="Tab One">
        <h4>Tab One</h4>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do
           eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
      </div>
      <div th-tab name="Tab One">
        <h4>Tab One</h4>
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do
           eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
      </div>
    </div>
  """

  compileDirective = (state, template) ->
    template = template ? validTemplate
    element = compile(template)(scope)
    scope.$digest()

    return element

  beforeEach module 'ThemisComponents'

  beforeEach inject ($injector) ->
    scope = $injector.get('$rootScope').$new()
    compile = $injector.get '$compile'

  beforeEach ->
    element = compileDirective()

  it 'should create a tab bar', ->
    expect(element.find('.th-tab-bar').length).toBe 1

  it 'should create a content area', ->
    expect(element.find('.th-tabset-content').length).toBe 1

  it 'should default to the first tab being visible', ->
    expect(element.find('.th-tab-bar a').first().hasClass('active')).toBe true
    expect(element.find('.th-tab-bar a').last().hasClass('active')).toBe false

  it 'should switch to the second tab if clicked', ->
    element.find('.th-tab-bar a').last().click()
    expect(element.find('.th-tab-bar a').first().hasClass('active')).toBe false
    expect(element.find('.th-tab-bar a').last().hasClass('active')).toBe true
