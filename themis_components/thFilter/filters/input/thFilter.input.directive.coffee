angular.module 'ThemisComponents'
  .directive 'thFilterInput', (InputFilter) ->
    restrict: 'E'
    scope:
      filterSet: '='
      filterOptions: '='
      ngBlur: '&'
      placeholder: '@'
    bindToController: true
    controllerAs: 'thFilterInput'
    template: require './thFilter.input.template.html'
    controller: ($scope) ->
      enterEventCode = 13

      @ngKeypress = (event) ->
        @filterSet.onFilterChange() if event.which is enterEventCode

      $scope.$on "$destroy", =>
        @filterSet.remove @filter

        if @filter.getValue()?
          @filterSet.onFilterChange()

      $scope.$on "th.filters.clear", =>
        @filter.clearValue()

      return
    compile: ->
      pre: (scope, element, attrs, controller) ->
        controller.filter = new InputFilter controller.filterOptions
        controller.filterSet.push controller.filter
