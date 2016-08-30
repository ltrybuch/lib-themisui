{
  compileDirective
} = require "spec_helpers"
context = describe

describe 'withLabel', ->
  element = null

  beforeEach angular.mock.module "ThemisComponents"

  context "HTML checkbox input", ->
    beforeEach ->
      element = compileDirective(
        """<input type="checkbox" with-label="HTML checkbox" ng-required="true">"""
      ).element

    it "appends inline label instead of prepends label", ->
      expect(element.next().is("span.inline.label-text")).toBe true

    it "adds 'with-label' value to label", ->
      expect(element.next().text()).toMatch "HTML checkbox"

    it "adds 'required' indicator to label", ->
      expect(element[0].hasAttribute("ng-required")).toBe true
      expect(element.prev().hasClass("required-field")).toBe true

  context "HTML radio input", ->
    beforeEach ->
      element = compileDirective(
        """<input type="radio" with-label="HTML radio" ng-required="true">"""
      ).element

    it "appends inline label instead of prepends label", ->
      expect(element.next().is("span.inline.label-text")).toBe true

    it "adds 'with-label' value to label", ->
      expect(element.next().text()).toMatch "HTML radio"

    it "adds 'required' indicator to label", ->
      expect(element[0].hasAttribute("ng-required")).toBe true
      expect(element.prev().hasClass("required-field")).toBe true

  context "HTML text input", ->
    beforeEach ->
      element = compileDirective(
        """<input type="text" with-label="HTML input type" ng-required="true">"""
      ).element

    it "wraps input in a label element", ->
      expect(element.parent().hasClass("th-label")).toBe true
      expect(element.parent().is("label")).toBe true

    it "adds inner div element with class 'label-text' above input element", ->
      expect(element.prev().is("div.label-text")).toBe true

    it "adds 'with-label' value to div.label-text text", ->
      expect(element.prev().text()).toMatch "HTML input type"

    it "adds 'required' indicator to label", ->
      expect(element[0].hasAttribute("ng-required")).toBe true
      expect(element.prev().prev().hasClass("required-field")).toBe true
