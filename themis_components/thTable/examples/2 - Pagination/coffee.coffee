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
    pageSize = 5
    data = fixtures 102
    initialData = data.slice 0, pageSize

    @tableDelegate = new SimpleTableDelegate
      data: initialData

      currentPage: 1
      pageSize: pageSize
      totalItems: data.length
      onChangePage: (page, updateData, pageSize) ->
        start = (page - 1) * pageSize
        end = start + pageSize
        updateData {data: data.slice(start, end)}

      headers: [
        new TableHeader
          name: 'First Name'

        new TableHeader
          name: 'Last Name'
      ]

    return
