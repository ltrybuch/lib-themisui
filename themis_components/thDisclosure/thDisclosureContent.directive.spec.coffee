context = describe
describe "ThemisComponents: Directive: thDisclosureContent", ->
  DisclosureManager = element = null

  context "when in default state (hidden)", ->
    beforeEach ->
      element = compileDirective("""<div th-disclosure-content="unique-id">Content</div>""").element

    it "is wrapped in a <div> with class 'th-disclosure-content'", ->
      expect(element.is('div')).toBe true
      expect(element.hasClass("th-disclosure-content")).toBe true

    it "has height 0", ->
      expect(element.css("height")).toEqual "0px"

    it "transcludes its children", ->
      expect(element.find('ng-transclude').text()).toEqual "Content"

  context "when expanded", ->
    beforeEach ->
      element = compileDirective("""
        <div>
          <div th-disclosure-toggle="unique-id">Toggle</div>
          <div th-disclosure-content="unique-id">Content</div>
        </div>
      """).element

    it "has real height", ->
      element.find('a').first().triggerHandler 'click'
      expect(element.find('div.th-disclosure-content').css("height")).not.toEqual "0px"

    it "animates", ->
      ctrl = element.find('div.th-disclosure-content').scope().$$childTail.thDisclosureContent
      spyOn ctrl, "animateToggle"
      element.find('a').first().triggerHandler 'click'
      expect(ctrl.animateToggle).toHaveBeenCalled()
