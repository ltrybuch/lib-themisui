angular.module 'ThemisComponents'
  .directive 'thCustomFilterRow', ($timeout) ->
    restrict: 'E'
    require: "^thCustomFilters"
    scope: true
    bindToController: true
    controllerAs: 'thCustomFilterRow'
    template: require './thCustomFilterRow.template.html'
    controller: ($scope) ->
      @rowSelectValue = null
      @rowIdentifier = 0
      @rowFilterOptions = []
      @checkboxOptions = [
        {name: "Enabled", value: "true"}
        {name: "Disabled", value: "false"}
      ]
      @numberOperatorOptions = [
        {name: "<", value: "<"}
        {name: "<=", value: "<="}
        {name: "=", value: "="}
        {name: ">=", value: ">="}
        {name: ">", value: ">"}
      ]
      @currencyOperatorOptions = [
        {name: "Less than", value: "<"}
        {name: "Exactly", value: "="}
        {name: "More than", value: ">"}
      ]

      @onRowSelectChange = =>
        $timeout =>
          @rowFilterOptions = []
          @rowFilterOptions.push @rowSelectValue if @rowSelectValue?

      @removeRow = =>
        $scope.thCustomFilters.removeCustomFilterRow @rowIdentifier

      return
    link: (scope, element, attrs) ->
      scope.thCustomFilterRow.rowIdentifier = attrs.index
