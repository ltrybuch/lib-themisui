module.exports =
  setUpElements: (inputType, scopeAdditions) ->
    ->
      scopeAdditions = Object.assign({pattern: /^[a-zA-Z ]*$/}, scopeAdditions)
      UsingCustomMsgs = -> "=messages" if scopeAdditions?

      template = """
        <form name="form">
          <th-#{inputType}
            with-messages#{UsingCustomMsgs()}
            name="inputName"
            ng-model="modelName"
            with-label="labelName"
            ng-required="true"
            ng-minLength="5"
            ng-maxLength="10"
            ng-pattern="pattern"
          >
          </th-#{inputType}>
        </form>
      """
      compileDirective(template, scopeAdditions)

  testValidationTypes: (options = {}) ->
    element = scope = null

    {validationTypes, name, messages} = options

    testValues =
      required: ""
      maxlength: "Johnny Blaze"
      minlength: "John"
      pattern: 12345

    validationTypes.forEach (type) ->
      describe "with a #{type} error", ->
        beforeEach ->
          {element, scope} = options.compileElementFn()
          scope.modelName = testValues[type]
          element.find(name).triggerHandler 'focus'
          element.find(name).triggerHandler 'blur'

        it "sets the form and element to invalid", ->
          expect(scope.form.$invalid).toBe true
          expect(scope.form.inputName.$error[type]).toBe true

        it "displays the error message element", ->
          expect(element.find(".message-text").length).toBe 1

        it "displays the custom '#{type}' error message", ->
          normalized = element.find(".message-text").text().trim()
          expect(messages[type]).toBe normalized

  testWithValidInput: (inputType, compileElementFn) ->
    element = scope = null

    beforeEach -> {element, scope} = compileElementFn()

    it "appends a message element to the element", ->
      expect(element.find(".th-with-message").length).toBe 1

    describe "with a valid input", ->
      beforeEach ->
        element.find(inputType).triggerHandler 'focus'
        scope.modelName = "Johnny"
        element.find(inputType).triggerHandler 'blur'

      it "keep the form and input to valid", ->
        expect(scope.form.$valid).toBe true
        expect(scope.form.inputName.$error.required).toBeUndefined()

      it "displays the error message element", ->
        expect(element.find(".message-text").length).toBe 0

  defaultMessages: ->
    return {
      required: "This field is required."
      minlength: "Please enter at least 5 characters."
      maxlength: "Please enter no more than 10 characters."
      pattern: "Invalid Response."
    }

  validTemplate: ->
    return """
      <form name="form">
        <th-switch
          name="switchName"
          ng-model="modelName"
          ng-required="true"
          with-messages="{{messages}}"
          >
        </th-switch>
        <th-checkbox
          name="checkboxName"
          ng-model="modelName"
          ng-required="true"
          with-messages="{{messages}}"
          >
        </th-checkbox>
        <th-radio-group
          ng-required="true"
          ng-model="radio"
          name="radioName"
          with-messages="{{messages}}"
        >
          <th-radio-button with-label="One" value="one"></th-radio-button>
          <th-radio-button with-label="Two" value="two"></th-radio-button>
        </th-radio-group>
        <a type="submit" href="#"></a>
      </form>
    """
