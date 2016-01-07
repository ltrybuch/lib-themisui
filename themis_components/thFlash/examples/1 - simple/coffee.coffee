angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (FlashManager) ->

    @displaySuccess = ->
      FlashManager.showFlash 'Your message has been sent successfully.', 'success'

    @displayError = ->
      FlashManager.showFlash 'An error occured while sending your message. Try again.', 'error'

    return
