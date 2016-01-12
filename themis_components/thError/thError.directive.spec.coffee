context = describe

describe "ThemisComponents: Directive: thError", ->
  element = null
  defaultMsg = "We had trouble loading your content.Try reloading the page."

  context "default component", ->
    it "displays the default text", ->
      element = compileDirective("<th-error></th-error>").element
      expect(element.text()).toMatch defaultMsg

  context "with transcluded elements", ->
    beforeEach ->
      element = compileDirective("<th-error><p>Error</p></th-error>").element

    it "does not show default text", ->
      expect(element.text()).not.toMatch defaultMsg

    it "transcludes elements", ->
      expect(element.find("p").length).toBe 1
      expect(element.find("p").text()).toMatch "Error"
