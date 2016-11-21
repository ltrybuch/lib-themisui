{
  compileDirective
} = require "spec_helpers"
context = describe

describe "ThemisComponents: Directive: thDisclosureToggle", ->
  DisclosureManager = element = null

  getFirstChild = (element) -> angular.element element.children()[0]

  beforeEach angular.mock.module "ThemisComponents"
  beforeEach ->
    element = compileDirective("""
      <th-disclosure-toggle name="unique-id">
        Toggle
      </th-disclosure-toggle>
    """).element

  context "when in default state (disabled)", ->
    it "renders an <a> element", ->
      firstChild = getFirstChild element
      expect(firstChild.is('a')).toBe true

    it "icon caret inits with class 'fa fa-caret-right'", ->
      expect(element.find('a span').hasClass("fa fa-caret-right")).toBe true

    it "transcludes its children", ->
      expect(element.find('a ng-transclude').text().trim()).toEqual "Toggle"

  context "when enabled", ->
    beforeEach ->
      a = getFirstChild element
      a.triggerHandler 'click'

    it "icon caret rotates clockwise 90 degrees", ->
      expect(element.find('a span').hasClass("fa fa-caret-right fa-caret-right-rotated")).toBe true

  describe "#toggle", ->
    it "calls DisclosureManager.toggle", ->
      inject (_DisclosureManager_) ->
        DisclosureManager = _DisclosureManager_

      spyOn DisclosureManager, "updateState"
      a = getFirstChild element
      a.triggerHandler 'click'
      expect(DisclosureManager.updateState).toHaveBeenCalled()
