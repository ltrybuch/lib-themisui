{
  compileDirective
} = require "spec_helpers"
context = describe

describe 'ThemisComponents: Filter: thPlural', ->
  element = scope = null
  beforeEach angular.mock.module 'ThemisComponents'

  beforeEach ->
    scopeAdditions = {count: 0}
    {element, scope} = compileDirective(
      """<div>{{count}} {{"name" | pluralize: count}}<div>""", scopeAdditions
    )

  context "when count == 0", ->
    it "displays the pluralized version of the word", ->
      expect(element.text()).toBe "0 names"

  context "when count == 1", ->
    it "displays the singular version of the word", ->
      scope.$apply -> scope.count = 1
      expect(element.text()).toBe "1 name"

  context "when count > 1", ->
    it "displays the pluralized version of the word", ->
      scope.$apply -> scope.count = 2
      expect(element.text()).toBe "2 names"

  context "when count > 0", ->
    it "displays the pluralized version of the word", ->
      scope.$apply -> scope.count = -1
      expect(element.text()).toBe "-1 names"

  context "when count is undefined", ->
    it "displays the pluralized version of the word", ->
      scope.$apply -> scope.count = undefined
      expect(element.text()).toBe " names"
