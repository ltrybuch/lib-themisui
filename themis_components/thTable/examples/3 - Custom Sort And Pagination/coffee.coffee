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

    pageSize = 5

    headers = [
      new TableHeader
        name: 'First Name'
        sortField: 'firstName'
        sortEnabled: 'ascending'

      new TableHeader
        name: 'Last Name'
        sortField: 'lastName'
    ]

    sortByHeader = (header) ->
      data.sort (a, b) ->
        result = a[header.sortField].localeCompare b[header.sortField]
        result = -result if header.sortEnabled is "descending"
        result

    getDataPage = (data, page) ->
      start = (page - 1) * pageSize
      end = start + pageSize
      data[start ... end]

    getCurrentSortHeader = ->
      headers.find (header) -> header.sortEnabled

    onSort = (header, updateData) ->
      updateData {
        data: getDataPage sortByHeader(header), 1
      }

    onChangePage = (page, updateData, pageSize) ->
      header = getCurrentSortHeader()
      start = (page - 1) * pageSize
      end = start + pageSize
      updateData {
        data: getDataPage sortByHeader(header), page
      }

    initialData = getDataPage sortByHeader(getCurrentSortHeader()), 1

    @tableDelegate = SimpleTableDelegate {
      data: initialData
      headers
      onSort

      currentPage: 1
      pageSize
      totalItems: data.length

      onChangePage
    }

    return
