{
  compileDirective
} = require "spec_helpers"
context = describe

describe "ThemisComponents: Directive: thDropdown", ->
  element = timeout = null

  beforeEach angular.mock.module "ThemisComponents"

  context "with default example", ->
    beforeEach ->
      element = compileDirective("""
        <th-dropdown name="button"></th-dropdown>
      """).element

    it "is wrapped in a <div> with class 'button-dropdown'", ->
      expect(element.hasClass("button-dropdown")).toBe true

    it "icon caret inits with class 'fa fa-caret-down'", ->
      expect(element.find("i").hasClass("fa fa-caret-down")).toBe true

    it "sets dropdown button text equal to name attr", ->
      expect(element.text()).toMatch "button"

    context "when clicked", ->
      beforeEach ->
        element.find('button').first().triggerHandler 'click'
      it "sets dropdown overlay to visible", ->
        expect(element.find("div.th-dropdown-overlay")).not.toBe null

      context "when backdrop is clicked", ->
        it "dismisses the dropdown list", ->
          element.find(".dd-overlay").triggerHandler 'click'
          expect(element.find("ul").length).toEqual 0

  context "with type", ->
    it "adds type name as a class to button", ->
      element = compileDirective("""
        <th-dropdown name="button" type="standard"></th-dropdown>
      """).element
      expect(element.find("button").first().hasClass("standard")).toBe true

  context "with link", ->
    beforeEach ->
      element = compileDirective("""
        <th-dropdown list="[{name:'link', href:'/example/link'}]"></th-dropdown>
      """).element

    context "when button is clicked", ->
      beforeEach ->
        element.find('button').first().triggerHandler 'click'

      it "displays a menu with items", ->
        expect(element.find(".dropdown-menu")).not.toBe null
        expect(element.find(".dropdown-item").length).toEqual 1

      it "icon caret inits with class 'fa fa-caret-up'", ->
        expect(element.find("i").hasClass("fa fa-caret-up")).toBe true

      it "adds a anchor tag to the dropdown item", ->
        a = element.find("a.dropdown-item")
        expect(a).not.toBe null
        expect(a.attr("href")).toMatch "/example/link"
        expect(a.text()).toMatch "link"

  context "link with an icon", ->
    beforeEach ->
      element = compileDirective("""
        <th-dropdown list="[{name:'link', href:'/example/link', icon: 'users'}]">
        </th-dropdown>
      """).element
    context "when button is clicked", ->
      beforeEach ->
        element.find('button').first().triggerHandler 'click'
      it "anchor has i element with class 'fa fa-users'", ->
        expect(element.find(".dropdown-item > i").hasClass("fa fa-users")).toBe true

  context "with ng-click", ->
    beforeEach ->
      scope = {}; scope.action = -> alert 'response'
      template = """
        <th-dropdown name="Button" list="[{name:'action', ngClick: action}]">
        </th-dropdown>
      """
      element = compileDirective(template, scope).element

    context "when button is clicked", ->
      beforeEach ->
        element.find('button').first().triggerHandler 'click'

      it "displays a menu with items", ->
        expect(element.find(".dropdown-menu")).not.toBe null
        expect(element.find(".dropdown-item").length).toEqual 1

      context "and when dropdown item is clicked", ->
        it "invokes the action", ->
          spyOn(window, 'alert')
          element.find('li').triggerHandler 'click'
          expect(window.alert).toHaveBeenCalledWith 'response'

  context "when keydown event is triggered", ->
    beforeEach ->
      scope = {}; scope.action = -> alert 'response'
      template = """
        <th-dropdown
          name="Button"
          list="[{name:'action 1', ngClick: action}, {name: 'action 2', ngClick: action}]"
        >
        </th-dropdown>
      """
      element = compileDirective(template, scope).element
      inject ($timeout) -> timeout = $timeout

    context "when keycode is '13' (Enter)", ->
      it "displays a menu with items", ->
        event = $.Event('keydown')
        event.keyCode = 13
        element.triggerHandler event
        expect(element.find(".dropdown-menu")).not.toBe null
        expect(element.find(".dropdown-item").length).toEqual 2

    context "when keycode is '32' (Space)", ->
      it "displays a menu with items", ->
        event = $.Event('keydown')
        event.keyCode = 32
        element.triggerHandler event
        expect(element.find(".dropdown-menu")).not.toBe null
        expect(element.find(".dropdown-item").length).toEqual 2

    context "when keycode is '27' (Esc)", ->
      it "displays a menu with items", ->
        openEvent = $.Event('keydown')
        openEvent.keyCode = 13
        element.triggerHandler openEvent

        spyOn element.find('button')[0], 'focus'
        escEvent = $.Event('keydown')
        escEvent.keyCode = 27
        element.triggerHandler escEvent
        expect(element.find(".dropdown-menu").length).toBe 0
        expect(element.find(".dropdown-item").length).toEqual 0
        expect(element.find('button')[0].focus).toHaveBeenCalled()

    context "when keycode is '40' (Down)", ->
      it "navigates to the second item in the list", ->
        openEvent = $.Event('keydown')
        openEvent.keyCode = 13
        element.triggerHandler openEvent

        spyOn element.find(".dropdown-item")[1], 'focus'
        downEvent = $.Event('keydown')
        downEvent.keyCode = 40
        element.triggerHandler downEvent
        timeout.flush()
        expect(element.find(".dropdown-item")[1].focus).toHaveBeenCalled()

        context "when keycode is '38' (Up)", ->
          it "navigates to the first item in the list", ->
            spyOn element.find(".dropdown-item")[0], 'focus'
            upEvent = $.Event('keydown')
            upEvent.keyCode = 38
            element.triggerHandler upEvent
            timeout.flush()
            expect(element.find(".dropdown-item")[0].focus).toHaveBeenCalled()

  context "action with an icon", ->
    beforeEach ->
      scope = {}; scope.action = -> alert 'reponse'
      template = """
        <th-dropdown name="Button" list="[{name:'action', ngClick: action, icon: 'users'}]">
        </th-dropdown>
      """
      element = compileDirective(template, scope).element
    context "when button is clicked", ->
      beforeEach ->
        element.find('button').first().triggerHandler 'click'
      it "anchor has i element with class 'fa fa-users'", ->
        expect(element.find("a.dropdown-item > i").hasClass("fa fa-users")).toBe true

  context "when divider is passed in", ->
    beforeEach ->
      element = compileDirective("""
        <th-dropdown name="Button" list="[{divider:true}]"></th-dropdown>
      """).element
      element.find('button').first().triggerHandler 'click'

    it "displays a menu with items", ->
      expect(element.find(".dropdown-menu")).not.toBe null
      expect(element.find("hr.th-divider").length).toEqual 1
