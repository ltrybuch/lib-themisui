angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (AlertManager) ->

    @displaySuccess = ->
      AlertManager.showSuccess(
        "Your message has been sent successfully."
      )

    @displayError = ->
      AlertManager.showError(
        "An error occured while sending your message. Try again."
      )

    @displayWarning = ->
      AlertManager.showWarning(
        "The selected contact does not have an email address."
      )

    return
