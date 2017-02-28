angular.module 'ThemisComponents'
  .controller 'thCustomFilterRow.controller', ($timeout, $scope) ->
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

    @onRowSelectChange = =>
      $timeout =>
        @initialState = null
        if @rowFilterOptions.length > 0
          @broadcastFilterDestroyed()
        @rowFilterOptions = if @rowSelectValue? then [@rowSelectValue] else []

    @customFieldDelegate =
      displayField: 'name'
      trackField: 'fieldIdentifier'
      fetchData: ({searchString}, updateData) =>
        if searchString?.length > 1
          lowerCaseSearchString = searchString.toLowerCase()
          updateData(
            @customFilterTypes.filter (filterType) ->
              filterType.name.toLowerCase().indexOf(lowerCaseSearchString) isnt -1
            , @showSearchHint
          )
        else
          updateData @customFilterTypes, @showSearchHint

    return
