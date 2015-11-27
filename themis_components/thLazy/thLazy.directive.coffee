angular.module('ThemisComponents')
  .directive "thLazy", ->
    restrict: "EA"
    template: require './thLazy.template.html'
    scope:
      src: "@src"
    controller: ($scope) ->
      $scope.loaded = no
      $scope.loadingComplete = -> $scope.loaded = yes
