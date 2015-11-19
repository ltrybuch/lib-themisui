context = describe

describe 'withLabel', ->
  element = null

  context "with th-switch", ->
    beforeEach ->
      element = compileDirective("""<th-switch with-label="switch name"></th-switch>""").element

    it "appends inline label instead of prepends label", ->
      expect(element.next().is("span.inline.label-text")).toBe true

    it "adds 'with-label' value to label", ->
      expect(element.next().text()).toMatch "switch name"
