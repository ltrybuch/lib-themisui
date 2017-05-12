{
  compileDirective
} = require "spec_helpers"
context = describe

describe 'withLabel', ->
  element = null

  beforeEach angular.mock.module "ThemisComponents"

  context "with th-textarea example", ->
    beforeEach ->
      element = compileDirective("""<th-textarea with-label="name"></th-textarea>""").element

    it "wraps textarea in a label element", ->
      expect(element.parent().hasClass("th-label")).toBe true
      expect(element.parent().is("label")).toBe true

    it "adds inner div element with class 'label-text' above input element", ->
      expect(element.prev().is("div.label-text")).toBe true

    it "adds 'with-label' value to div.label-text text", ->
      expect(element.prev().text()).toMatch "name"
