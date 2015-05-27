angular = require 'angular'

angular.module('ThemisComponentsApp')
  .controller 'AppController', ($scope, $rootScope, $timeout, $http) ->
    # Uncomment the line below to auto load a component during development.
    $timeout -> $rootScope.$broadcast 'selectedComponent', 'thTabset'