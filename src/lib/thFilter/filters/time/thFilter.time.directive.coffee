angular.module "ThemisComponents"
  .directive "thFilterTime", (TimeFilter, $timeout) ->
    restrict: "E"
    scope:
      filterSet: "="
      filterOptions: "="
      ngBlur: "&"
      initialState: "=?"
    bindToController: true
    controllerAs: "thFilterTime"
    template: require "./thFilter.time.template.html"
    controller: ($scope, $element) ->
      lastValue = undefined
      enterEventCode = 13
      @operatorOptions = [
        {name: "Before", value: "<"}
        {name: "Exactly", value: "="}
        {name: "After", value: ">"}
      ]
      @defaultOperatorIndex = 1

      isUpdatedValue = =>
        newValue = @filter.model or undefined

        if newValue isnt lastValue
          lastValue = newValue
          return true
        return false

      setValid = ->
        $timeout -> $element.querySelectorAll(".th-input-wrapper").removeClass "is-invalid"

      setInvalid = ->
        $timeout -> $element.querySelectorAll(".th-input-wrapper").addClass "is-invalid"

      @validateInput = ->
        if @filter.validate() then setValid() else setInvalid()
        if isUpdatedValue()
          @filterSet.onFilterChange()

      @onKeypress = (event) ->
        @validateInput() if event.which is enterEventCode

      @onOperatorChange = ->
        @filterSet.onFilterChange() if @filter.time

      @$onInit = ->
        lastValue = @initialState?.value

      $scope.$on "$destroy", =>
        @filterSet.remove @filter

        if @filter.getState()?
          @filterSet.onFilterChange()

      $scope.$on "th.filters.clear", =>
        setValid()
        @filter.clearState()

      return
    compile: ->
      pre: (scope, element, attrs, controller) ->
        controller.filter = new TimeFilter(
          controller.filterOptions
          controller.operatorOptions
          controller.defaultOperatorIndex
          controller.initialState
        )
        controller.filterSet.push controller.filter
