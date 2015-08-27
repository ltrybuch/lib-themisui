context = describe
describe "ThemisComponents: Directive: thDropdown", ->
  element = null

  context "with default example", ->
    beforeEach ->
      element = compileDirective("""<th-dropdown name="button"></th-dropdown>""").element

    it "is wrapped in a <div> with class 'button-dropdown'", ->
      expect(element.hasClass("button-dropdown")).toBe true

    it "icon caret inits with class 'fa fa-caret-down'", ->
      expect(element.find("i").hasClass("fa fa-caret-down")).toBe true

    it "sets dropdown button text equal to name attr", ->
      expect(element.text()).toMatch "button"

    context "when clicked", ->
      beforeEach ->
        element.find('a').first().triggerHandler 'click'
      it "sets dropdown overlay to visible", ->
        expect(element.find("div.th-dropdown-overlay")).not.toBe null

      context "when backdrop is clicked", ->
        it "dismisses the dropdown list", ->
          element.find(".dd-overlay").triggerHandler 'click'
          expect(element.find("ul").length).toEqual 0

  context "with color", ->
    it "adds color name as a class to button", ->
      element = compileDirective("""<th-dropdown name="button" color="grey"></th-dropdown>""").element
      expect(element.find("a").first().hasClass("grey")).toBe true

  context "with link", ->
    beforeEach ->
      element = compileDirective("""<th-dropdown list="[{name:'link', url:'/example/link'}]"></th-dropdown>""").element

    context "when button is clicked", ->
      beforeEach ->
        element.find('a').first().triggerHandler 'click'

      it "displays a ul with li", ->
        expect(element.find("ul")).not.toBe null
        expect(element.find("li").length).toEqual 1

      it "icon caret inits with class 'fa fa-caret-up'", ->
        expect(element.find("i").hasClass("fa fa-caret-up")).toBe true

      it "adds a anchor tag to the li", ->
        a = element.find("li > a")
        expect(a).not.toBe null
        expect(a.attr("href")).toEqual "/example/link"
        expect(a.text()).toMatch "link"

  context "link with an icon", ->
    beforeEach ->
      element = compileDirective("""<th-dropdown list="[{name:'link', url:'/example/link', icon: 'users'}]"></th-dropdown>""").element
    context "when button is clicked", ->
      beforeEach ->
        element.find('a').first().triggerHandler 'click'
      it "li has icon with class 'fa fa-users'", ->
        expect(element.find("li > a > i").hasClass("fa fa-users")).toBe true

  context "with action", ->
    beforeEach ->
      template = """<th-dropdown name="Button" list="[{name:'action', action: action}]"></th-dropdown>"""
      element = compileDirective(template, {action: -> alert 'response'}).element

    context "when button is clicked", ->
      beforeEach ->
        element.find('a').first().triggerHandler 'click'

      it "adds an anchor tag with 'ng-click' set to action attr", ->
        expect(element.find("li > a").attr('ng-click')).toEqual "item.action()"

      it "displays a ul with li", ->
        expect(element.find("ul")).not.toBe null
        expect(element.find("li").length).toEqual 1

      context "and when li is clicked", ->
        it "invokes the action", ->
          spyOn(window, 'alert')
          element.find('li > a').triggerHandler 'click'
          expect(window.alert).toHaveBeenCalledWith 'response'

  context "action with an icon", ->
    beforeEach ->
      template = """<th-dropdown name="Button" list="[{name:'action', action: action, icon: 'users'}]"></th-dropdown>"""
      element = compileDirective(template, {action: -> alert 'response'}).element
    context "when button is clicked", ->
      beforeEach ->
        element.find('a').first().triggerHandler 'click'
      it "li has icon with class 'fa fa-users'", ->
        expect(element.find("li > a > i").hasClass("fa fa-users")).toBe true

  context "when divider is passed in", ->
    beforeEach ->
      element = compileDirective("""<th-dropdown name="Button" list="[{type:'divider'}]"></th-dropdown>""").element
      element.find('a').first().triggerHandler 'click'

      it "displays a ul with li", ->
        expect(element.find("ul")).not.toBe null
        expect(element.find("li").length).toEqual 1

      it "li has class 'divider'", ->
        expect(element.find("li").hasClass("divider")).toBe true


