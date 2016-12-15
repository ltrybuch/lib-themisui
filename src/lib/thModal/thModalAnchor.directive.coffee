angular.module("ThemisComponents")
  .directive "thModalAnchor", ->
    restrict: "EA"
    replace: true
    controllerAs: "anchor"
    bindToController: true
    template: require './thModalAnchor.template.html'
    controller: (ModalManager) ->
      @modals = ModalManager._modals

      return
