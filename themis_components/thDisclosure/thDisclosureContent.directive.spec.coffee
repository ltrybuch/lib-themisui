context = describe
describe "ThemisComponents: Directive: thDisclosureContent", ->
  DisclosureManager = element = null

  getFirstChild = (element) -> angular.element element.children()[0]

  context "when in default state (hidden)", ->
    beforeEach ->
      element = compileDirective("""
        <th-disclosure-content name="unique-id">
          Content
        </th-disclosure-content>
      """).element

    it "renders a <ng-transclude> component", ->
      firstChild = getFirstChild element
      expect(firstChild.is('ng-transclude')).toBe true

    it "has height 0", ->
      expect(element.css("height")).toEqual "0px"

  context "when expanded", ->
    beforeEach ->
      element = compileDirective("""
        <div>
          <th-disclosure-toggle name="unique-id">Toggle</th-disclosure-toggle>
          <th-disclosure-content name="unique-id">Content</th-disclosure-content>
        </div>
      """).element
      angular.element('body').append element

    afterEach ->
      element.remove()

    it "has real height", (done) ->
      element.find('a').first().triggerHandler 'click'
      setTimeout ->
        expect(element.find('div.th-disclosure-content').css("height")).not.toEqual "0px"
        done()
      , 301 # The animation duration is 300ms

  context "when toggle expanded attribute set to true", ->
    beforeEach ->
      element = compileDirective("""
        <div>
          <th-disclosure-toggle name="unique-id" expanded="true">Toggle</th-disclosure-toggle>
          <th-disclosure-content name="unique-id">Content</th-disclosure-content>
        </div>
      """).element
      angular.element('body').append element

    afterEach ->
      element.remove()

    it "has real height", (done) ->
      setTimeout ->
        expect(element.find('div.th-disclosure-content').css("height")).not.toEqual "0px"
        done()
      , 301 # The animation duration is 300ms

    it "toggles closed and back open", ->
      ctrl = element.find('th-disclosure-content ng-transclude').scope().thDisclosureContent
      spyOn ctrl, "close"
      element.find('a').first().triggerHandler 'click'
      expect(ctrl.close).toHaveBeenCalled()
      spyOn ctrl, "open"
      element.find('a').first().triggerHandler 'click'
      expect(ctrl.open).toHaveBeenCalled()
