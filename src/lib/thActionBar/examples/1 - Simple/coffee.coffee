angular.module("thActionBarDemo")
  .controller "thActionBarDemoCtrl1", (
    SimpleTableDelegate
    TableHeader
    TableSort
    ActionBarDelegate
    FilterSet
    $timeout
  ) ->
    ################# Relevant example code here ###############################
    # thActionBar: Let's set up our action bar delegate.
    @delegate = new ActionBarDelegate
      buttonName: "Generate"
      onApply: ({ids, selectedAction}, reset) =>
        @ids = ids
        @selectedAction = selectedAction
        console.log "selectedAction in controller: ", selectedAction
        $timeout ->
          reset()
        , 3000
      availableActions: [
        {name: "print", value: "print"}
        {name: "Download Archive", value: "download"}
      ]

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
        paginatedSortedData = getDataPage(sortedData, currentPage, pageSize)

        ################# Relevant example code here ###########################
        # thActionBar: On every table change lets update the action bar.
        paginatedSortedSelectedableData = @delegate.makeSelectable paginatedSortedData

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
