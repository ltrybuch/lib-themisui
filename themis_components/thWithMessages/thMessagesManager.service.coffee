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
      min = attrs.ngMinlength ? ""
      max = attrs.ngMaxlength ? ""

      defaultMessages =
        required: "This field is required."
        minlength: "Please enter at least #{min} characters."
        maxlength: "Please enter no more than #{max} characters."
        pattern: "Invalid Response."

      return Object.assign({}, defaultMessages, messages)

    return Object.freeze {
      extendMessages
      generateNgMessagesElement
    }
