angular.module 'ThemisComponents'
  .factory 'AlertManager', ($sce) ->
    alertMessage = {}

    showSuccess = (message) ->
      alertMessage.message = $sce.trustAsHtml message
      alertMessage.type = 'success'

    showError = (message) ->
      alertMessage.message = $sce.trustAsHtml message
      alertMessage.type = 'error'

    showWarning = (message) ->
      alertMessage.message = $sce.trustAsHtml message
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
