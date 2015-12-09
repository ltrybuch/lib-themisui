angular.module('ThemisComponents')
  .directive "thLazy", ->
    restrict: "EA"
    template: require './thLazy.template.html'
    scope:
      src: "@"
      errorMessage: "@"
    controller: ($scope) ->
      $scope.loaded = no
      $scope.loadError = no
      $scope.errorMessage =
        $scope.errorMessage ? "Missing View. Try reloading or, contact support."

      $scope.loadingComplete = ->
        $scope.loaded = yes

      $scope.$on "$includeContentError", (event, args) ->
        $scope.loadError = yes
