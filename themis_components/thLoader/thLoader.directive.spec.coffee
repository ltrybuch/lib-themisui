{
  compileDirective
} = require "spec_helpers"
context = describe

describe 'ThemisComponents: Directive: thLoader', ->
  element = q = timeout = scope = null

  beforeEach angular.mock.module "ThemisComponents"

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
      inject ($timeout, $q) -> timeout = $timeout; q = $q
      deferred = q.defer(); promise = deferred.promise
      scopeAdditions =
        deferred: deferred
        promise: promise

      directive = compileDirective('<div th-loader promise="promise"></div>', scopeAdditions)
      element = directive.element
      scope = directive.scope

      timeout (-> scope.deferred.resolve()), 10

    it 'hide after promise is resolved', ->
      timeout.flush(11)
      expect(element.hasClass('ng-hide')).toBe true

    it 'shows before promise is resolved', ->
      timeout.flush(9)
      expect(element.hasClass('ng-hide')).toBe false

  context "with size 'large' attribute", ->
    beforeEach ->
      element = compileDirective('<div th-loader size="large"></div>').element

    it "has class 'large'", ->
      expect(element.find("div.progress").hasClass("large")).toBe true

  context "with size 'small' attribute", ->
    beforeEach ->
      element = compileDirective('<div th-loader size="small"></div>').element

    it "has should not have class 'large'", ->
      expect(element.find("div.progress").hasClass("large")).toBe false

  context "with size 'mini' attribute", ->
    beforeEach ->
      element = compileDirective('<div th-loader size="mini"></div>').element

    it "has should have class 'mini'", ->
      expect(element.find("div.progress").hasClass("mini")).toBe true

    it "should hide the 'loading' paragraph", ->
      expect(element.find("p.loading-text").hasClass("ng-hide")).toBe true

  context "with theme attribute", ->
    beforeEach ->
      {element} = compileDirective("""<div th-loader theme="'light'"></div>""")

    it "should pass the attribute as a class to the loader", ->
      expect(element.hasClass("light")).toBe true
