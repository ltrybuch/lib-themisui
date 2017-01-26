angular.module("thFilterDemo")
  .controller "thFilterDemoCtrl5", (
    SimpleTableDelegate
    TableHeader
    TableSort
    FilterSet
    $http
  ) ->
    {sort} = TableSort

    @filterSet = new FilterSet
      onFilterChange: =>
        @query = @filterSet.getState()
        @tableDelegate.reload {currentPage: 1}
      onInitialized: =>
        @query = @filterSet.getState()
        @tableDelegate.reload {currentPage: 1}

    @filterOptions = {
      filterSet: @filterSet
      staticFilters: [
        name: "Name"
        type: "select"
        fieldIdentifier: "userId"
        placeholder: "Select a user"
        selectOptionsUrl: "http://jsonplaceholder.typicode.com/users"
        selectOptionsCallback: (data) ->
          data.map (item) ->
            name: item.name
            value: item.id
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
      initialState:
        completed:
          value: "true"
        q:
          value: "temporibus"
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
        state = @filterSet.getState()
        queryString = ""
        for key in Object.keys state
          queryString += "#{key}=#{state[key].value}&"
        $http
          method: "GET"
          url: "http://jsonplaceholder.typicode.com/todos?" + queryString
        .then (response) ->
          sortedData = sort response.data, sortHeader
          start = (currentPage - 1) * pageSize
          end = currentPage * pageSize
          updateData {data: sortedData.slice(start, end), totalItems: sortedData.length}

    return
