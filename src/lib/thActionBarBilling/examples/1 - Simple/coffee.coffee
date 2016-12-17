angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (
    SimpleTableDelegate
    TableHeader
    TableSort
    $scope
    ActionBarBillingDelegate
    FilterSet
    $timeout
    $q
  ) ->
    ################# Relevant example code here ###############################
    # thActionBar: Let's set up our action bar delegate.
    @actionBarDelegate = new ActionBarBillingDelegate
      retrieveIds: (vm) -> $q.when allIds(55)
      # Function to be called whenever our "Apply" button is clicked.
      onApply: ({trackedCollection, selectedAction}, triggerReset) =>
        @ids = trackedCollection.map((id) -> return id.id).toString()
        @selectedAction = selectedAction
        triggerReset()
      availableActions: [
        {name: "print", value: "print"}
        {name: "Download Archive", value: "download"}
      ]
      collectionReferences: ["parent"]

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
        paginatedSortedData =
          collection: getDataPage(sortedData, currentPage, pageSize)
          meta: totalItems: @data.length

        ################# Relevant example code here ###########################
        # thActionBar: On every table change lets update the action bar.
        paginatedSortedSelectedableData =
          @actionBarDelegate.makeSelectable paginatedSortedData

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

allIds = (count) -> [1 .. count].map (number) -> number
