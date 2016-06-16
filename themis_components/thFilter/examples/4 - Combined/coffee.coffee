angular.module "thDemo", ["ThemisComponents"]
  .controller "DemoController", (
    SimpleTableDelegate
    TableHeader
    TableSort
    FilterSet
    $http
  ) ->
    {sort} = TableSort

    @filterSet = new FilterSet
      onFilterChange: (filters) =>
        @tableDelegate.reload {currentPage: 1}

    @filterOptions = {
      filterSet: @filterSet
      staticFilters: [
        name: "Name"
        type: "select"
        fieldIdentifier: "userId"
        placeholder: "Select a user"
        selectOptionsUrl: "http://jsonplaceholder.typicode.com/users"
        selectOptionsNameField: "name"
        selectOptionsValueField: "id"
      ]
      customFilterTypes: [
        name: "Completed"
        type: "select"
        fieldIdentifier: "completed"
        selectOptions: [
          {name: "True", value: "true"}
          {name: "False", value: "false"}
        ]
      ]
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
        TableHeader
          name: "Completed"
          sortField: "completed"
      ]
      pageSize: 10
      fetchData: ({currentPage, pageSize, sortHeader}, updateData) =>
        query = @filterSet.getQueryString()
        $http
          method: "GET"
          url: "http://jsonplaceholder.typicode.com/todos?" + query
        .then (response) ->
          sortedData = sort response.data, sortHeader
          start = (currentPage - 1) * pageSize
          end = currentPage * pageSize
          updateData {data: sortedData.slice(start, end), totalItems: sortedData.length}

    return
