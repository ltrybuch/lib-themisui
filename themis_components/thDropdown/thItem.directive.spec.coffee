context = describe
describe "ThemisComponents: Directive: thItem", ->
  element = null

  context "with url", ->
    beforeEach ->
      element = compileDirective("""<th-item name="First" url="#"><th-item>""").element
    it "replace directive with div with class 'dropdown-item'", ->
      expect(element.find(".dropdown-item")).not.toBe null
    it "add anchor element", ->
      expect(element.find("a").length).toEqual 1
    it "sets text of anchor with name attribute", ->
      expect(element.find("a").text()).toMatch "First"
    it "set anchor element href attr with url attribute", ->
      expect(element.find("a").attr("href")).toMatch "#"

  context "with icon", ->
    beforeEach ->
      element = compileDirective("""<th-item name="first" url="#" icon="icn"></th-item>""").element
    it "add i element to the anchor element", ->
      expect(element.find("i").length).toEqual 1
    it "sets class based on icon attribute", ->
      expect(element.find("i").hasClass("fa fa-icn"))

  context "with action", ->
    beforeEach ->
      template = """<th-item name="First" action="action"></th-item>"""
      element = compileDirective(template, {action: -> alert 'response'}).element
    it "adds attr 'ng-click' set to action attr", ->
      expect(element.find("a").attr('ng-click')).toMatch "action()"
    it "adds attr 'href' with value of '#'", ->
      expect(element.find("a").attr("href")).toMatch "#"
    it "replace directive with div with class 'dropdown-item'", ->
      expect(element.find(".dropdown-item")).not.toBe null
    it "add anchor element", ->
      expect(element.find("a").length).toEqual 1
    it "sets text of anchor with name attribute", ->
      expect(element.find("a").text()).toMatch "First"

    context "and when dropdown item is clicked", ->
      it "invokes the action", ->
        spyOn(window, 'alert')
        element.find('a').triggerHandler 'click'
        expect(window.alert).toHaveBeenCalledWith 'response'
