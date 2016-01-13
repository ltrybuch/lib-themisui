angular.module('ThemisComponents').directive "thAlert", ->
  restrict: "E"
  bindToController: true
  controllerAs: 'alert'
  template: require './thAlert.template.html'
  controller: (AlertManager) ->
    @alertMessage = AlertManager.alertMessage

    @dismiss = ->
      AlertManager.hideAlert()

    return
