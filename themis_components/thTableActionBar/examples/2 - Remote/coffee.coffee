angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (
    SimpleTableDelegate
    TableHeader
    ActionBarDelegate
    FilterSet
    $http
    $timeout
    AlertManager
  ) ->

    ################# Relevant example code here ###############################
    # thTableActionBar: Let's set up our action bar delegate.
    @actionBarDelegate = new ActionBarDelegate
      # Function to be called whenever our "Apply" button is clicked.
      onApply: ({trackedCollection, allSelected, selectedAction}, reset) =>
        @ids = trackedCollection
        @allSelected = allSelected
        @selectedAction = selectedAction

        # Simulate a bulk action process and return success message.
        $timeout ->
          reset()
          AlertManager.showSuccess "Your post have been processed."
        , 3000
      pageSize: 10

    # thTableActionBar: Link to the select column on each row.
    @toggleSelected = (viewObject) ->
      @actionBarDelegate.toggleSelected(viewObject)

    updateActionBar = (data, currentPage, totalItems) =>
      @actionBarDelegate.makeSelectable
        data: data
        totalItems: totalItems
        currentPage: currentPage

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
          .then (response) ->
            data = response.data
            resCount = response.headers "X-Total-Count"
            totalItems = if data.length > resCount then data.length else resCount

            ################# Relevant example code here #######################
            # thTableActionBar: On every table change lets update the action bar.
            selectableData = updateActionBar data, currentPage, totalItems

            updateData {data: selectableData, totalItems: totalItems}

    return
