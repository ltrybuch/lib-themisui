describe 'ThemisComponents: Directive: thLoader', ->
  element = scope = compile = q = timeout = null

  delay = 1000
  message = "checking..."

  promiseTemplate = '<div th-loader promise="promise"></div>'
  timerTemplate = '<div th-loader timeout="delay"></div>'

  customTextTemplate = '<div th-loader>' + message + '</div>'
  defaultTextTemplate = '<div th-loader></div>'

  compileDirective = (template) ->
    element = compile(template)(scope)
    scope.$digest()
    return element

  beforeEach ->
    module 'ThemisComponents'

    inject ($rootScope, $compile, $q, $timeout) ->
      scope = $rootScope.$new()
      compile = $compile
      q = $q
      timeout = $timeout

  it 'transcludes passed in custom text', ->
    element = compileDirective(customTextTemplate)
    msgElement = element.find('span')[0]

    expect(msgElement.innerHTML).toBe message

  it 'defaults to "Loading..." when no text is passed', ->
    element = compileDirective(defaultTextTemplate)
    msgElement = element.find('p.loading-text')[0]

    expect(msgElement.innerHTML).toBe 'Loading...'

  it 'should have a class "th-loader"', ->
    expect(element.hasClass('th-loader')).toBe true

  describe "passing timeout to loader", ->
    beforeEach ->
      scope.delay = delay
      element = compileDirective(timerTemplate)

    it "after timeout passes is not visible", ->
      timeout.flush(delay + 1)
      expect(element.hasClass("ng-hide")).toBe true

    it "before timeout passes is it visible", ->
      timeout.flush(delay - 1)
      expect(element.hasClass("ng-hide")).toBe false

  describe "passing promise to loader", ->
    beforeEach ->
      deferred = q.defer()
      scope.promise = deferred.promise
      timeout ->
        deferred.resolve()
      , delay
      element = compileDirective(promiseTemplate)

    it "is hidden after promise is resolved", ->
      timeout.flush(delay + 1)
      expect(element.hasClass("ng-hide")).toBe true

    it "is visible before promise is resolved", ->
      timeout.flush(delay - 1)
      expect(element.hasClass("ng-hide")).toBe false

