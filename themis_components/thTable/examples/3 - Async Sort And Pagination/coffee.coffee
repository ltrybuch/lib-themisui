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

  people


angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (SimpleTableDelegate, TableHeader, TableSort, $scope) ->
    data = fixtures 102
    {sort} = TableSort

    getDataPage = (data, page, pageSize) ->
      start = (page - 1) * pageSize
      end = start + pageSize
      data[start ... end]

    @tableDelegate = SimpleTableDelegate {
      headers: [
        TableHeader
          name: 'First Name'
          sortField: 'firstName'
          sortActive: true
          sortDirection: 'ascending'

        TableHeader
          name: 'Last Name'
          sortField: 'lastName'
      ]

      currentPage: 1
      pageSize: 5

      fetchData: (page, pageSize, sortHeader, updateData) ->
        delay = 1000
        sortedData = sort data, sortHeader
        paginatedSortedData = getDataPage sortedData, page, pageSize
        totalItems = data.length
        setTimeout ->
          updateData undefined, paginatedSortedData, totalItems
          $scope.$apply()
        , delay
    }

    return
