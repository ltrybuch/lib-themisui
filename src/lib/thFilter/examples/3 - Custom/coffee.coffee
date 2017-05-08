expectedFilterTypes = require "../../tests/fixtures/filterTypes"

angular.module("thFilterDemo")
  .controller "thFilterDemoCtrl3", (
    SimpleTableDelegate
    TableHeader
    TableSort
    FilterSet
  ) ->
    filterTypes = expectedFilterTypes.items

    {sort} = TableSort
    data = expectedFilterTypes.data 30

    @filterSet = new FilterSet
      onFilterChange: =>
        @tableDelegate.reload {currentPage: 1}

    @filterOptions = {
      filterSet: @filterSet
      customFilterTypes: filterTypes
    }

    @tableDelegate = SimpleTableDelegate
      # This map is required to keep TableHeader out of the filterTypes fixture file
      headers: expectedFilterTypes.headers.map (header) -> TableHeader header

      fetchData: ({sortHeader}, updateData) =>
        filteredData = data

        for identifier, state of @filterSet.getState()
          if state?
            filteredData = filteredData.filter (item) ->
              item[identifier] is state.value

        sortedData = sort filteredData, sortHeader
        updateData {data: sortedData, totalItems: sortedData.length}

    return
