context = describe
describe "ThemisComponents: Directive: thDisclosureToggle", ->
  DisclosureManager = element = null

  beforeEach ->
    element = compileDirective("""<div th-disclosure-toggle="unique-id">Toggle</div>""").element

  context "when in default state (disabled)", ->
    it "is wrapped in a <a> with class 'th-disclosure-toggle'", ->
      expect(element.is('a')).toBe true
      expect(element.hasClass("th-disclosure-toggle")).toBe true

    it "icon caret inits with class 'fa fa-caret-right'", ->
      expect(element.find('span').hasClass("fa fa-caret-right")).toBe true

    it "transcludes its children", ->
      expect(element.find('ng-transclude').text()).toEqual "Toggle"

  context "when enabled", ->
    beforeEach ->
      element.triggerHandler 'click'

    it "icon caret rotates clockwise 90 degrees", ->
      expect(element.find('span').hasClass("fa fa-caret-right fa-caret-right-rotated")).toBe true

  describe "#toggle", ->
    it "calls DisclosureManager.toggle", ->
      inject (_DisclosureManager_) ->
        DisclosureManager = _DisclosureManager_

      spyOn DisclosureManager, "toggle"
      element.triggerHandler 'click'
      expect(DisclosureManager.toggle).toHaveBeenCalled()
