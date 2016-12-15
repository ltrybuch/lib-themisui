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
      enterEventCode = 13
      @operatorOptions = [
        {name: "Before", value: "<"}
        {name: "Exactly", value: "="}
        {name: "After", value: ">"}
      ]
      @defaultOperatorIndex = 1

      setValid = ->
        $timeout -> $element.querySelectorAll(".th-input-wrapper").removeClass("is-invalid")

      setInvalid = ->
        $timeout -> $element.querySelectorAll(".th-input-wrapper").addClass("is-invalid")

      @validateInput = ->
        if @filter.validate() then setValid() else setInvalid()
        @filterSet.onFilterChange()

      @onKeypress = (event) ->
        @validateInput() if event.which is enterEventCode

      @onOperatorChange = ->
        @filterSet.onFilterChange() if @filter.time

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
