angular.module 'ThemisComponents'
  .factory 'AlertManager', ->
    alertMessage = {}

    showSuccess = (message) ->
      alertMessage.message = message
      alertMessage.type = 'success'

    showError = (message) ->
      alertMessage.message = message
      alertMessage.type = 'error'

    showWarning = (message) ->
      alertMessage.message = message
      alertMessage.type = 'warning'

    hideAlert = ->
      alertMessage.message = ''
      alertMessage.type = ''

    return {
      showSuccess
      showError
      showWarning
      hideAlert
      alertMessage
    }
