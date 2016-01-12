angular.module('ThemisComponents')
  .directive "thLazy", ->
    restrict: "EA"
    template: require './thLazy.template.html'
    scope:
      src: "@"
      errorMessage: "@"
    controller: ($scope) ->
      $scope.loading = yes
      $scope.loadError = no
      $scope.messageOverride = $scope.errorMessage?
      $scope.loadingComplete = ->
        $scope.loading = no

      $scope.$on "$includeContentError", (event, args) ->
        $scope.loadError = yes
        $scope.loading = no
