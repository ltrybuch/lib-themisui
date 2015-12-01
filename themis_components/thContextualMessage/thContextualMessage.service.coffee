angular.module('ThemisComponents')
  .factory 'ContextualMessageManager', ($timeout) ->
    messages = {}

    initializeMessagesForContext = (context) ->
      messages[context] = [] unless messages[context]?

    showMessage = (context, message, timeout = 2000) ->
      initializeMessagesForContext context

      messages[context].push
        text: message
        timeout: timeout

    messagesForContext = (context) ->
      initializeMessagesForContext context

      return messages[context]

    showedMessageForContext = (context) ->
      initializeMessagesForContext context

      $timeout ->
        messagesForContext(context).shift()
      , messagesForContext(context)[0].timeout

    return {
      showMessage
      showedMessageForContext
      messagesForContext
    }