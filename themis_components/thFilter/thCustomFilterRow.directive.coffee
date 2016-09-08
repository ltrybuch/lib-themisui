angular.module 'ThemisComponents'
  .directive 'thCustomFilterRow', ($timeout) ->
    restrict: 'E'
    require: "^thCustomFilters"
    scope:
      rowSelectValue: "="
      initialState: "=?"
      customFilterTypes: "="
      filterSet: "="
      removeRow: "&"
    bindToController: true
    controllerAs: 'thCustomFilterRow'
    template: require './thCustomFilterRow.template.html'
    controller: ($scope) ->
      @rowFilterOptions = []
      @rowFilterOptions.push @rowSelectValue if @rowSelectValue

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
          @initialState = null
          @rowFilterOptions = []
          @rowFilterOptions.push @rowSelectValue if @rowSelectValue?

      return
