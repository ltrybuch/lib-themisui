angular.module "ThemisComponents"
  .directive "thFilterDate", (DateFilter) ->
    restrict: "E"
    scope:
      filterSet: "="
      filterOptions: "="
      placeholder: "@"
    bindToController: true
    controllerAs: "thFilterDate"
    template: require "./thFilter.date.template.html"
    controller: ($scope) ->
      @onValueChange = (event) =>
        @filterSet.onFilterChange()

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
          controller.initialState
        )

        controller.filterSet.push controller.filter

        return
