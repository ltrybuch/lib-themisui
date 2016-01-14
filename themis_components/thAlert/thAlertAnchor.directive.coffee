angular.module('ThemisComponents').directive "thAlertAnchor", ->
  restrict: "E"
  bindToController: true
  controllerAs: 'alertAnchor'
  template: require './thAlertAnchor.template.html'
  controller: (AlertManager) ->
    @alertMessage = AlertManager.alertMessage

    @dismiss = ->
      AlertManager.hideAlert()

    return
