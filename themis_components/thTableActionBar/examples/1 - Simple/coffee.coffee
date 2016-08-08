angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (
    SimpleTableDelegate
    TableHeader
    TableSort
    $scope
    ActionBarDelegate
    FilterSet
  ) ->

    ################# Relevant example code here ###############################
    # thTableActionBar: Let's set up our action bar delegate.
    @actionBarDelegate = new ActionBarDelegate
      # Function to be called whenever our "Apply" button is clicked.
      onApply: ({trackedCollection, allSelected, selectedAction}, triggerReset) =>
        @ids = trackedCollection
        @allSelected = allSelected
        @selectedAction = selectedAction
        triggerReset()

      availableActions: [
        {name: "Print", value: "print"}
        {name: "Download Archive", value: "download"}
      ]
      pageSize: 10

    # thTableActionBar: Link to the select column on each row.
    @toggleSelected = (viewObject) ->
      @actionBarDelegate.toggleSelected(viewObject)

    # thTableActionBar: Trigger on each table refresh.
    updateActionBar = (data, currentPage, totalItems) =>
      @actionBarDelegate.makeSelectable
        data: data
        totalItems: totalItems
        currentPage: currentPage

    # Table fixture code here.
    getDataPage = (data, page, pageSize) ->
      start = (page - 1) * pageSize
      end = start + pageSize
      return data[start ... end]

    {sort} = TableSort
    @data = fixtures(55)

    @tableDelegate = SimpleTableDelegate
      headers: [
        TableHeader {name: '', width: "52px"}
        TableHeader {name: 'ID #', sortField: 'id', sortActive: true}
        TableHeader {name: 'First Name', sortField: 'firstName'}
        TableHeader {name: 'Last Name', sortField: 'lastName'}
        TableHeader {name: 'Email', sortField: 'email'}
      ]
      pageSize: 10

      fetchData: ({currentPage, pageSize, sortHeader}, updateData) =>
        sortedData = sort @data, sortHeader
        paginatedSortedData = getDataPage sortedData, currentPage, pageSize

        ################# Relevant example code here ###########################
        # thTableActionBar: On every table change lets update the action bar.
        paginatedSortedSelectedableData =
          updateActionBar paginatedSortedData, currentPage, @data.length

        updateData {data: paginatedSortedSelectedableData, totalItems: @data.length}

    return

# Sample data here.
fixtures = (length) ->
  getRandomInt = (min, max) ->
    Math.floor(Math.random() * (max - min + 1)) + min

  capitalizeFirstLetter = (string) ->
    string[0].toUpperCase() + string[1 ..]

  generateName = ->
    possible = 'abcdefghijklmnopqrstuvwxyz'
    length = getRandomInt 5, 10
    text = ''
    text += possible[getRandomInt 0, possible.length - 1] for i in [1 .. length]
    capitalizeFirstLetter text

  people = []
  for i in [1 .. length]
    people.push
      id: i
      firstName: generateName()
      lastName: generateName()
      email: generateName()

  return people
