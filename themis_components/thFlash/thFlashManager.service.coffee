angular.module 'ThemisComponents'
  .factory 'FlashManager', ->
    flashMessage = {}

    showFlash = (message, type) ->
      flashMessage.message = message
      flashMessage.type = type

    hideFlash = ->
      flashMessage.message = ''
      flashMessage.type = ''

    return {
      showFlash
      hideFlash
      flashMessage
    }
