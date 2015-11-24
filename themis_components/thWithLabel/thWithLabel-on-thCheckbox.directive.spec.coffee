context = describe

describe 'withLabel', ->
  element = null

  context "with th-checkbox", ->
    beforeEach ->
      element = compileDirective("""<th-checkbox with-label="checkbox name"></th-checkbox>""").element

    it "appends inline label instead of prepends label", ->
      expect(element.next().is("span.inline.label-text")).toBe true

    it "adds 'with-label' value to label", ->
      expect(element.next().text()).toMatch "checkbox name"
