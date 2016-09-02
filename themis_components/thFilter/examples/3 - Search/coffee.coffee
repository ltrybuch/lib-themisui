angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (
    SimpleTableDelegate
    TableHeader
    TableSort
    FilterSet
    $http
  ) ->
    {sort} = TableSort

    @filterSet = new FilterSet
      onFilterChange: =>
        @tableDelegate.reload {currentPage: 1}

    @filterOptions = {
      filterSet: @filterSet
    }

    @tableDelegate = SimpleTableDelegate
      headers: [
        TableHeader
          name: "User Id"
          sortField: "userId"
          width: "100px"
        TableHeader
          name: "Id"
          sortActive: true
          sortField: "id"
        TableHeader
          name: "Title"
          sortField: "title"
      ]
      pageSize: 10
      fetchData: ({currentPage, pageSize, sortHeader}, updateData) =>
        query = @filterSet.getQueryString()
        $http
          method: 'GET'
          url: "http://jsonplaceholder.typicode.com/albums?" + query
        .then (response) ->
          sortedData = sort response.data, sortHeader
          start = (currentPage - 1) * pageSize
          end = currentPage * pageSize
          updateData {data: sortedData.slice(start, end), totalItems: sortedData.length}

    return
