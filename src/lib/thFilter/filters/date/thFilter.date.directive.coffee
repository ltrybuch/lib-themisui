angular.module "ThemisComponents"
  .directive "thFilterDate", (DateFilter) ->
    restrict: "E"
    scope:
      filterSet: "="
      filterOptions: "="
      operatorOptions: "=?"
      defaultOperatorIndex: "@?"
      placeholder: "@?"
      initialState: "=?"
    bindToController: true
    controllerAs: "thFilterDate"
    template: require "./thFilter.date.template.html"
    controller: ($scope) ->
      @hasOperator = @operatorOptions?.length > 0

      @onValueChange = => @filterSet.onFilterChange()

      @onOperatorChange = =>
        @filterSet.onFilterChange() if @filter.model?

      $scope.$on "$destroy", =>
        @filterSet.remove @filter

        if @filter.getState()?
          @filterSet.onFilterChange()

        return

      $scope.$on "th.filters.clear", =>
        @filter.clearState()

      return
    compile: ->
      pre: (scope, element, attrs, controller) ->
        controller.filter = new DateFilter(
          controller.filterOptions
          controller.operatorOptions
          controller.defaultOperatorIndex
          controller.initialState
        )

        controller.filterSet.push controller.filter
        return
