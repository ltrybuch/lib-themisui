angular = require 'angular'

angular.module('ThemisComponentsApp')
  .controller 'AppController', ($scope, $rootScope, $timeout, $http) ->
    $timeout -> $rootScope.$broadcast 'selectedComponent', 'thPopover'