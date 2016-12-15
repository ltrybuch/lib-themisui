angular.module 'ThemisComponents'
  .directive 'thFilterSelect', (SelectFilter, $timeout) ->
    restrict: 'E'
    scope:
      filterSet: '='
      filterOptions: '='
      options: '='
      placeholder: '@'
      initialState: '=?'
    bindToController: true
    controllerAs: 'thFilterSelect'
    template: require './thFilter.select.template.html'
    controller: ($scope) ->
      @onValueChange = ->
        $timeout =>
          @filterSet.onFilterChange()

      $scope.$on "$destroy", =>
        @filterSet.remove @filter

        if @filter.getState()?
          @filterSet.onFilterChange()

      $scope.$on "th.filters.clear", =>
        @filter.clearState()

      return
    compile: ->
      pre: (scope, element, attrs, controller) ->
        controller.filter = new SelectFilter(
          controller.filterOptions
          controller.options
          controller.initialState
        )
        controller.filterSet.push controller.filter
