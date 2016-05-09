angular.module 'ThemisComponents'
  .directive 'thFilterInput', (InputFilter) ->
    restrict: 'E'
    scope:
      filterSet: '='
      filterOptions: '='
    bindToController: true
    controllerAs: 'thFilterInput'
    template: require './thFilter.input.template.html'
    controller: ($scope) ->
      enterEventCode = 13

      @filter = new InputFilter @filterOptions
      @filterSet.push @filter

      @onKeypress = (event) ->
        @filterSet.onFilterChange() if event.which is enterEventCode

      $scope.$on "$destroy", =>
        @filterSet.remove @filter

        if @filter.getValue()?
          @filterSet.onFilterChange()

      return
