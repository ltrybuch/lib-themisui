angular.module("thActionBarDemo")
  .controller "thActionBarDemoCtrl2", (
    SimpleTableDelegate
    TableHeader
    FilterSet
    $http
    $timeout
    AlertManager
    ActionBarDelegate
  ) ->

    ################# Relevant example code here ###############################
    # thActionBar: Let's set up our action bar delegate.
    @delegate = new ActionBarDelegate
      onApply: ({ids, selectedAction}, reset) =>
        @ids = ids
        @selectedAction = selectedAction
        $timeout ->
          reset()
        , 1000

    fetchAllIds = ->
      $timeout ->
        return $q (resolve) ->
          $http.get "http://jsonplaceholder.typicode.com/posts"
            .then (data) ->
              resolve data.data.map (item) -> item.id
      , 200

    # Filter fixture code here.
    generateQueryString = (params) ->
      queryString = ""
      queryString += "#{k}=#{v}&" for k, v of params
      return queryString.slice 0, -1

    @filterSet = new FilterSet
      onFilterChange: (filters) =>
        @tableDelegate.reload {currentPage: 1}

    @filterOptions = {filterSet: @filterSet}

    # Table fixture code here.
    @tableDelegate = SimpleTableDelegate
      headers: [
        TableHeader {name: '', width: "52px"}
        TableHeader {name: 'ID #'}
        TableHeader {name: 'Title'}
        TableHeader {name: 'Body'}
      ]
      pageSize: 10

      fetchData: ({currentPage, pageSize, sortHeader}, updateData) =>
        params =
          _limit: pageSize
          _start: (currentPage - 1) * pageSize
          _end: ((currentPage - 1) * pageSize) + pageSize
        state = @filterSet.getState()
        for k in Object.keys(state)
          params[k] = state[k].value

        queryString = generateQueryString(params)
        $http.get("http://jsonplaceholder.typicode.com/posts?#{queryString}")
          .then (response) =>
            data = response.data
            resCount = response.headers "X-Total-Count"
            totalItems = if data.length > resCount then data.length else resCount

            @ids = null
            ################# Relevant example code here #######################
            # thActionBar: On every table change lets update the action bar.
            selectableData = @delegate.makeSelectable data

            updateData {data: selectableData, totalItems: totalItems}

    return
