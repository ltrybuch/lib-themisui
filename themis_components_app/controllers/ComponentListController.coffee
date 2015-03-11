angular.module('ThemisComponentsApp')
    .controller 'ComponentListController', ($rootScope, $scope, $http) ->
        $scope.components = []
        $scope.viewType = 'as-list'

        $scope.chooseComponent = (component) ->
            $rootScope.$broadcast 'selectedComponent', component

        $scope.$on 'selectedComponent', (event, component) ->
            $scope.selectedComponent = component

        $http.get '/dev_tools/components.json'
        .then (response) ->
            $scope.components = response.data
