angular.module "ThemisComponents"
  .directive "thFilterInput", (InputFilter) ->
    restrict: "E"
    scope:
      filterSet: "="
      filterOptions: "="
      ignoreBlurEvents: "<?"
      placeholder: "@"
      initialState: "=?"
    bindToController: true
    controllerAs: "thFilterInput"
    template: require "./thFilter.input.template.html"
    controller: ($scope) ->
      lastValue = undefined
      enterEventCode = 13

      isUpdatedValue = =>
        newValue = @filter.getState()?.value

        if newValue isnt lastValue
          lastValue = newValue
          return true
        return false

      @onKeypress = (event) =>
        if isUpdatedValue()
          @filterSet.onFilterChange() if event.which is enterEventCode

      @onBlur = (event) =>
        if isUpdatedValue()
          unless @ignoreBlurEvents
            @filterSet.onFilterChange()

      @$onInit = ->
        lastValue = @initialState?.value
        @ignoreBlurEvents or= false

      $scope.$on "thFilter:destroyed", =>
        @filterSet.remove @filter

        if @filter.getState()?
          @filterSet.onFilterChange()

      $scope.$on "th.filters.clear", =>
        @filter.clearState()

      return
    compile: ->
      pre: (scope, element, attrs, controller) ->
        controller.filter = new InputFilter(
          controller.filterOptions
          controller.initialState
        )

        controller.filterSet.push controller.filter
