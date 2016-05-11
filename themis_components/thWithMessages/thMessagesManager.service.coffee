angular.module 'ThemisComponents'
  .factory 'MessageService', ->

    generateInputSpecificConditional = (options) ->
      {formName, modelName, isInlineEl} = options

      # Checkbox and radio inputs can only be validated on submit.
      if isInlineEl
        """#{formName}.$submitted && #{formName}.#{modelName}.$invalid"""
      else
        """#{formName}.#{modelName}.$invalid &&
        (#{formName}.#{modelName}.$touched || #{formName}.$submitted)"""

    generateNgMessagesElement = (options) ->
      {messages, formName, modelName} = options

      return """<div class="th-with-message"></div>""" unless formName and modelName

      conditional = generateInputSpecificConditional options

      messageWrapper = """
        <div class="th-with-message">
          <div
            ng-messages="#{formName}.#{modelName}.$error"
            class="message-container"
            ng-if="#{conditional}"
            >
        """

      messages = Object.keys(messages).map (validityType) ->
        """<span class="message-text" ng-message="#{validityType}">
            #{messages[validityType]}
          </span>
        """
      .join ""

      "#{messageWrapper}#{messages}</div></div>"

    extendMessages = (messages, attrs) ->
      minLength = attrs.ngMinlength ? ""
      maxLength = attrs.ngMaxlength ? ""

      minNumberValue = attrs.min ? 0
      maxNumberValue = attrs.max ? 0
      hasNumberRange = attrs.max? and attrs.min?

      soloMinNumberMsg =
        "Please enter a valid number equal to or greater than #{minNumberValue}."
      soloMaxNumberMsg =
        "Please enter a valid number less than or equal to #{maxNumberValue}."
      rangeNumberMsg =
        "Please enter a number between #{minNumberValue} and #{maxNumberValue}."

      defaultMessages =
        required: "This field is required."
        minlength: "Please enter at least #{minLength} characters."
        maxlength: "Please enter no more than #{maxLength} characters."
        pattern: "Invalid Response."
        number: "Please enter a number."
        min: if hasNumberRange then rangeNumberMsg else soloMinNumberMsg
        max: if hasNumberRange then rangeNumberMsg else soloMaxNumberMsg

      return Object.assign({}, defaultMessages, messages)

    return Object.freeze {
      extendMessages
      generateNgMessagesElement
    }
