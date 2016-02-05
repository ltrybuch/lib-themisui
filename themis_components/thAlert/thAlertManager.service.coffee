angular.module 'ThemisComponents'
  .factory 'AlertManager', ($sce, $timeout) ->
    alertMessage = {}
    timer = ''

    showSuccess = (message, params) ->
      showAlert(message, params)
      alertMessage.type = 'success'

    showError = (message, params) ->
      showAlert(message, params)
      alertMessage.type = 'error'

    showWarning = (message, params) ->
      showAlert(message, params)
      alertMessage.type = 'warning'

    showAlert = (message, params) ->
      params ?= ""
      alertMessage.message = $sce.trustAsHtml message
      timeout params.timeout

    hideAlert = ->
      alertMessage.message = ''
      alertMessage.type = ''
      $timeout.cancel(timer)

    timeout = (duration) ->
      $timeout.cancel(timer)

      if duration != 0
        duration = duration || 3000
        timer = $timeout ->
          hideAlert()
          $timeout.cancel(timer)
        , duration

    return {
      showSuccess
      showError
      showWarning
      showAlert
      hideAlert
      alertMessage
      timeout
    }
