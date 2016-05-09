angular.module 'ThemisComponents'
  .directive 'thFilterSelect', (SelectFilter, $timeout) ->
    restrict: 'E'
    scope:
      filterSet: '='
      filterOptions: '='
    bindToController: true
    controllerAs: 'thFilterSelect'
    template: require './thFilter.select.template.html'
    controller: ($scope) ->
      @filter = new SelectFilter @filterOptions
      @filterSet.push @filter

      @onValueChange = ->
        $timeout =>
          @filterSet.onFilterChange()

      $scope.$on "$destroy", =>
        @filterSet.remove @filter

        if @filter.getValue()?
          @filterSet.onFilterChange()

      return
