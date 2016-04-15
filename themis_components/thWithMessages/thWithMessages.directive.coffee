$ = require 'jquery'

angular.module('ThemisComponents')
  .directive "withMessages", ($compile, MessageService) ->
    restrict: "A"
    # Note: Post links run in reverse priority order. So set 'withLabel'
    # directive first and then run 'withMessages' after. Counterintiutive yes,
    # but this is how it works.
    # https://docs.angularjs.org/api/ng/service/$compile
    priority: 2
    require: ['?^form', '?^ngModel']
    link: (scope, element, attrs, controllersArray) ->
      formName = controllersArray[0]?.$name
      modelName = controllersArray[1]?.$name
      isInlineEl = element.hasClass "th-radio-group" or
        $(element).find("input:checkbox").length > 0

      throw new Error "with-message: missing model name on input." unless modelName?
      throw new Error "with-message: missing form." unless formName?
      throw new Error "with-message: missing field name on input." unless attrs.name?

      adjustLabelMargin = ->
        if attrs.withLabel?
          # For th-radio-group we need to remove margin from the last radio button.
          $(element).find(".radio-label:last-child")?.addClass "margin-bottom-none"
          $(element).closest("label").addClass "margin-bottom-none"

      compiledAndAppendMessageTemplate = (options) ->
        template = MessageService.generateNgMessagesElement(options)
        compiledTemplate = $compile(template)(scope)

        if attrs.withLabel?
          element.parent().append compiledTemplate
        else
          element.after compiledTemplate

        adjustLabelMargin()

      initialMessages = scope.$eval attrs.withMessages
      messages = MessageService.extendMessages initialMessages, attrs

      compiledAndAppendMessageTemplate({messages, isInlineEl, formName, modelName})
