context = describe

describe 'thTextarea', ->
  element = null

  context 'with complete example', ->
    beforeEach ->
      {element} = compileDirective("""
        <th-textarea
          name="nickname"
          rows="5"
          placeholder="Enter your nickname">
        </th-textarea>
      """)
    it "removes the icon element when the icon attribute is not specified", ->
      expect(element.find("i").length).toBe 0

    it "gains class 'has-focus' when in focus", ->
      element.find("textarea").triggerHandler 'focus'
      expect(element.hasClass("has-focus")).toBe true

    it "loses class 'has-focus' when blurred", ->
      element.find("textarea").triggerHandler 'focus'
      expect(element.hasClass("has-focus")).toBe true
      element.find("textarea").triggerHandler 'blur'
      expect(element.hasClass("has-focus")).toBe false

    describe 'textarea', ->
      it 'has appropriate attributes set', ->
        textarea = element.find("textarea").first()

        expect(textarea.attr("rows")).toBe '5'
        expect(textarea.attr("name")).toBe 'nickname'
        expect(textarea.attr("placeholder")).toBe 'Enter your nickname'

  context "with icon", ->
    beforeEach ->
      {element} = compileDirective(
        """<th-textarea icon="dollar"></th-textarea>""")

    it "adds an icon with the specified icon class", ->
      expect(element.find("i").hasClass("fa-dollar")).toBeTruthy()

    it "adds with-icon to the input field", ->
      expect(element.find("textarea").hasClass("with-icon")).toBeTruthy()

  context "with validations", ->
    beforeEach ->
      scopeAdditions =
        pattern: /^[a-zA-Z ]*$/
      {element} = compileDirective("""
        <th-textarea
          ng-required="true"
          ng-minLength="10"
          ng-maxLength="20"
          ng-pattern="pattern">
        </th-textarea>""", scopeAdditions)

    describe "textarea", ->
      it "has all ng-requirements added", ->
        textarea = element.find("textarea")[0]
        expect(textarea.hasAttribute("ng-required")).toBe true
        expect(textarea.hasAttribute("required")).toBe true
        expect(textarea.hasAttribute("ng-minLength")).toBe true
        expect(textarea.hasAttribute("ng-maxLength")).toBe true
        expect(textarea.hasAttribute("ng-pattern")).toBe true
        expect(textarea.getAttribute("ng-pattern")).toEqual '/^[a-zA-Z ]*$/'
        expect(textarea.getAttribute("ng-minLength")).toEqual '10'
        expect(textarea.getAttribute("ng-maxLength")).toEqual '20'
        expect(textarea.getAttribute("ng-pattern")).toEqual '/^[a-zA-Z ]*$/'

    context "with ng-disabled evaluating to true", ->
      beforeEach ->
        {element} = compileDirective(
          """<th-textarea ng-disabled="true"></th-textarea>""")

      describe "the textarea", ->
        it "is disabled", ->
          expect(element.find("textarea").attr("disabled")).toEqual "disabled"
          expect(element.find("textarea").hasClass("disabled")).toBe true
