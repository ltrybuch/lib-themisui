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
  .controller "DemoController", (SimpleTableDelegate, TableHeader) ->
    data = fixtures 102

    getDataPage = (data, page, pageSize) ->
      start = (page - 1) * pageSize
      end = start + pageSize
      data[start ... end]

    @tableDelegate = SimpleTableDelegate {
      headers: [
        new TableHeader
          name: 'First Name'

        new TableHeader
          name: 'Last Name'
      ]

      pageSize: 5

      fetchData: ({currentPage, pageSize}, updateData) ->
        paginatedData = getDataPage data, currentPage, pageSize
        updateData {data: paginatedData, totalItems: data.length}
    }

    return
