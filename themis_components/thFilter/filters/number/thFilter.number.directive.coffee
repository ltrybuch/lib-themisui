angular.module 'ThemisComponents'
  .directive 'thFilterNumber', (NumberFilter) ->
    restrict: 'E'
    scope:
      filterSet: '='
      filterOptions: '='
      ngBlur: '&'
      operatorOptions: '='
      defaultOperatorIndex: '@'
    bindToController: true
    controllerAs: 'thFilterNumber'
    template: require './thFilter.number.template.html'
    controller: ($scope) ->
      enterEventCode = 13

      @onKeypress = (event) ->
        @filterSet.onFilterChange() if event.which is enterEventCode

      @onOperatorChange = ->
        @filterSet.onFilterChange() if @filter.model?

      $scope.$on "$destroy", =>
        @filterSet.remove @filter

        if @filter.getValue()?
          @filterSet.onFilterChange()

      $scope.$on "th.filters.clear", =>
        @filter.clearValue()

      return
    compile: ->
      pre: (scope, element, attrs, controller) ->
        controller.filter = new NumberFilter(
          controller.filterOptions
          controller.operatorOptions
          controller.defaultOperatorIndex
        )
        controller.filterSet.push controller.filter
