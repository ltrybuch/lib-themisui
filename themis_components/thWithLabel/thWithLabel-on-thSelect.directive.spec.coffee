context = describe

describe 'withLabel', ->
  element = null

  context "with th-select", ->
    beforeEach ->
      additions = {}
      additions.options = [{name: "first", value: 1}, {name: "second", value: 2}]
      element = compileDirective("""<th-select options="options" with-label="select name"></th-select>""", additions).element

    it "adds inner div element with class 'label-text' above input element", ->
      expect(element.prev().is("div.label-text")).toBe true

    it "adds 'with-label' value to div.label-text text", ->
      expect(element.prev().text()).toMatch "select name"
