context = describe

describe 'withLabel', ->
  element = null

  context 'with input type text example', ->
    beforeEach ->
      element = compileDirective("""<th-input with-label="name"></th-input>""").element
    it "wraps input in a label element", ->
      expect(element.parent().hasClass("th-label")).toBe true
      expect(element.parent().is("label")).toBe true

    it "adds inner div element with class 'label-text' above input element", ->
      expect(element.prev().is("div.label-text")).toBe true

    it "adds 'with-label' value to div.label-text text", ->
      expect(element.prev().text()).toMatch "name"

  context "with th-switch", ->
    beforeEach ->
      element = compileDirective("""<th-switch with-label="switch name"></th-switch>""").element

    it "appends inline label instead of prepends label", ->
      expect(element.next().is("span.inline.label-text")).toBe true

    it "adds 'with-label' value to label", ->
      expect(element.next().text()).toMatch "switch name"

  context "with th-checkbox", ->
    beforeEach ->
      element = compileDirective("""<th-checkbox with-label="checkbox name"></th-checkbox>""").element

    it "appends inline label instead of prepends label", ->
      expect(element.next().is("span.inline.label-text")).toBe true

    it "adds 'with-label' value to label", ->
      expect(element.next().text()).toMatch "checkbox name"

  context "HTML checkbox input", ->
    beforeEach ->
      element = compileDirective("""<input type="checkbox" with-label="HTML checkbox">""").element

    it "appends inline label instead of prepends label", ->
      expect(element.next().is("span.inline.label-text")).toBe true

    it "adds 'with-label' value to label", ->
      expect(element.next().text()).toMatch "HTML checkbox"

  context "HTML radio input", ->
    beforeEach ->
      element = compileDirective("""<input type="radio" with-label="HTML radio">""").element

    it "appends inline label instead of prepends label", ->
      expect(element.next().is("span.inline.label-text")).toBe true

    it "adds 'with-label' value to label", ->
      expect(element.next().text()).toMatch "HTML radio"
