angular.module('ThemisComponents').directive "thFlash", ->
  restrict: "E"
  bindToController: true
  controllerAs: 'flash'
  template: require './thFlash.template.html'
  controller: (FlashManager) ->
    @flashMessage = FlashManager.flashMessage

    @dismiss = ->
      FlashManager.hideFlash()

    return
