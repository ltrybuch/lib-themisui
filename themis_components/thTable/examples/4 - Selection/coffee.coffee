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
  .controller "DemoController", (SimpleTableDelegate, TableHeader, TableSort) ->
    viewObject = (object) ->
      return {
        selected: isSelected object
        object
      }

    @selectedObjects = []

    isSelected = (object) =>
      if @selectedObjects.find((o) -> o is object) then true else false

    @toggleSelected = (viewObject) =>
      idx = @selectedObjects.indexOf viewObject.object
      if idx isnt -1
        @selectedObjects.splice idx, 1
      else
        @selectedObjects.push viewObject.object

    data = fixtures(102).map viewObject
    {sort} = TableSort

    getDataPage = (data, page, pageSize) ->
      start = (page - 1) * pageSize
      end = start + pageSize
      data[start ... end]

    @tableDelegate = SimpleTableDelegate {
      headers: [
        TableHeader
          name: ''

        TableHeader
          name: 'First Name'
          sortField: 'object.firstName'
          sortActive: true

        TableHeader
          name: 'Last Name'
          sortField: 'object.lastName'
      ]

      pageSize: 5

      fetchData: (options, updateData) ->
        {currentPage, pageSize, sortHeader} = options
        sortedData = sort data, sortHeader
        paginatedSortedData = getDataPage sortedData, currentPage, pageSize
        updateData {data: paginatedSortedData, totalItems: data.length}
    }

    return
