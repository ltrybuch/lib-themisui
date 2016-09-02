angular.module 'ThemisComponents'
  .directive 'thFilterSelect', (SelectFilter, $timeout) ->
    restrict: 'E'
    scope:
      filterSet: '='
      filterOptions: '='
      options: '='
      placeholder: '@'
      initialValue: '@'
    bindToController: true
    controllerAs: 'thFilterSelect'
    template: require './thFilter.select.template.html'
    controller: ($scope) ->
      @onValueChange = ->
        $timeout =>
          @filterSet.onFilterChange()

      $scope.$on "$destroy", =>
        @filterSet.remove @filter

        if @filter.getValue()?
          @filterSet.onFilterChange()

      $scope.$on "th.filters.clear", =>
        @filter.clearValue()

      return
    compile: ->
      pre: (scope, element, attrs, controller) ->
        controller.filter = new SelectFilter(
          controller.filterOptions
          controller.options
          controller.initialValue
        )
        controller.filterSet.push controller.filter
