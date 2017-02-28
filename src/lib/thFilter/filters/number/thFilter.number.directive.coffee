angular.module "ThemisComponents"
  .directive "thFilterNumber", (NumberFilter) ->
    restrict: "E"
    scope:
      filterSet: "="
      filterOptions: "="
      operatorOptions: "="
      defaultOperatorIndex: "@"
      initialState: "=?"
    bindToController: true
    controllerAs: "thFilterNumber"
    template: require "./thFilter.number.template.html"
    controller: ($scope) ->
      lastValue = undefined
      enterEventCode = 13

      isUpdatedValue = =>
        newValue = @filter.getState()?.value

        if newValue isnt lastValue
          lastValue = newValue
          return true
        return false

      @onKeypress = (event) ->
        if isUpdatedValue()
          @filterSet.onFilterChange() if event.which is enterEventCode

      @onBlur = (event) =>
        if isUpdatedValue()
          @filterSet.onFilterChange()

      @$onInit = ->
        lastValue = @initialState?.value

      @onOperatorChange = ->
        @filterSet.onFilterChange() if @filter.model?

      $scope.$on "thFilter:destroyed", =>
        @filterSet.remove @filter

        if @filter.getState()?
          @filterSet.onFilterChange()

      $scope.$on "th.filters.clear", =>
        @filter.clearState()

      return
    compile: ->
      pre: (scope, element, attrs, controller) ->
        controller.filter = new NumberFilter(
          controller.filterOptions
          controller.operatorOptions
          controller.defaultOperatorIndex
          controller.initialState
        )

        controller.filterSet.push controller.filter
