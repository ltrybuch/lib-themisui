angular = require 'angular'

angular.module('ThemisComponentsApp')
  .controller 'ComponentListController', ($rootScope, $scope, $http, $location) ->
    $scope.components = []
    $scope.viewType = 'as-list'

    $scope.chooseComponent = (component) ->
      $rootScope.$broadcast 'selectedComponent', component

    $scope.$on 'selectedComponent', (event, component) ->
      $scope.selectedComponent = component

    $http.get "/components.json"
    .then (response) ->
      $scope.components = response.data
