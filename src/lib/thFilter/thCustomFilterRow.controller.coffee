angular.module 'ThemisComponents'
  .controller 'thCustomFilterRow.controller', ($timeout, $scope, DataSource) ->
    @rowFilterOptions = if @rowSelectValue then [@rowSelectValue] else []

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
    @dateOperatorOptions = [
      {name: "Before", value: "<"}
      {name: "On", value: "="}
      {name: "After", value: ">"}
    ]

    @broadcastFilterDestroyed = -> $scope.$broadcast "thFilter:destroyed"

    @removeRow = =>
      @onRemoveRow()
      @broadcastFilterDestroyed()

    @onRowSelectChange = (value) =>
      $timeout =>
        @initialState = null

        if @rowFilterOptions.length > 0
          lastSelectedType = @rowFilterOptions[0][@customFieldOptions.trackField]
          currentSelectedType = value?[@customFieldOptions.trackField]

          if lastSelectedType isnt currentSelectedType
            @broadcastFilterDestroyed()

        @rowFilterOptions = if @rowSelectValue then [@rowSelectValue] else []

    @customFieldOptions =
      autoBind: false,
      displayField: 'name'
      trackField: 'fieldIdentifier'
      filter: "contains"
      dataSource: @customFilterTypesDataSource

    return
