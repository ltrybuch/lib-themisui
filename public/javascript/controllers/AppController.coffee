angular = require 'angular'

angular.module('ThemisComponentsApp')
  .controller 'AppController', ($scope, $http) ->

    $http.get("/version.json")
    .then (response) ->
      $scope.version = "v#{response.data.version}"

    return
