angular.module("ThemisComponents")
  .directive "thError", ->
    restrict: "E"
    transclude: true
    template: require './thError.template.html'
    scope:
      message: "@"
    controllerAs: "ctrl"
    bindToController: true
    controller: -> return
    link: (scope, elm, attr, ctrl, $transclude) ->
      $transclude (clone) ->
        scope.ctrl.message = true if clone.length
