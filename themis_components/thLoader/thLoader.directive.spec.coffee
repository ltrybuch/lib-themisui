context = describe

describe 'ThemisComponents: Directive: thLoader', ->
  element = q = timeout = scope = null

  context 'with text passed in', ->
    beforeEach ->
      element = compileDirective('<div th-loader>checking...</div>').element

    it 'adds custom message', ->
      expect(element.find(".loading-text span").text()).toBe "checking..."

    it 'adds span with class "ng-scope"', ->
      span = element.find(".loading-text span")

      expect(span.length).toBe 1
      expect(span.hasClass("ng-scope")).toBeTruthy()

  context "with no text passed in", ->
    beforeEach ->
      element = compileDirective("<div th-loader></div>").element

    it "adds default message", ->
      expect(element.find(".loading-text").text()).toBe "Loading..."

  context "with timeout", ->
    beforeEach ->
      element = compileDirective("<div th-loader timeout='10'></div>").element

      inject ($timeout) -> timeout = $timeout

    it 'hides after timeout complete', ->
      timeout.flush(11)
      expect(element.hasClass("ng-hide")).toBe true

    it "shows before timeout passes", ->
      timeout.flush(9)
      expect(element.hasClass("ng-hide")).toBe false

  context "with promise", ->
    beforeEach ->
      directive = compileDirective('<div th-loader promise="promise"></div>', {promise: true})
      element = directive.element
      scope = directive.scope

      inject ($timeout, $q) -> timeout = $timeout
      timeout (-> scope.deferred.resolve()), 10

    it 'hide after promise is resolved', ->
      timeout.flush(11)
      expect(element.hasClass('ng-hide')).toBe true

    it 'shows before promise is resolved', ->
      timeout.flush(9)
      expect(element.hasClass('ng-hide')).toBe false

  context "with size 'lg' attribute", ->
    beforeEach ->
      element = compileDirective('<div th-loader size="lg"></div>').element

    it "has class 'icon-lg'", ->
      expect(element.find("div.sk-spinner").hasClass("icon-lg")).toBe true

  context "with size 'sm' attribute", ->
    beforeEach ->
      element = compileDirective('<div th-loader size="sm"></div>').element

    it "has should not have class 'icon-lg'", ->
      expect(element.find("div.sk-spinner").hasClass("icon-lg")).toBe false
