angular.module("thTableDemo")
  .controller "thTableDemoCtrl3", (SimpleTableDelegate, TableHeader, TableSort, $timeout) ->
    data = fixtures 102
    {sort} = TableSort

    getDataPage = (data, page, pageSize) ->
      start = (page - 1) * pageSize
      end = start + pageSize
      data[start ... end]

    @tableDelegate = SimpleTableDelegate
      headers: [
        TableHeader
          name: 'First Name'
          sortField: 'firstName'
          sortActive: true

        TableHeader
          name: 'Last Name'
          sortField: 'lastName'
      ]

      pageSize: 5

      fetchData: ({currentPage, pageSize, sortHeader}, updateData) ->
        sortedData = sort data, sortHeader
        paginatedSortedData = getDataPage sortedData, currentPage, pageSize
        $timeout ->
          updateData {data: paginatedSortedData, totalItems: data.length}
        , 1000

    return


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
    people.push {firstName: generateName(), lastName: generateName()}

  return people
