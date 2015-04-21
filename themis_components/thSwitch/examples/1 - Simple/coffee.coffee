angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', ($scope) ->
    $scope.state = off