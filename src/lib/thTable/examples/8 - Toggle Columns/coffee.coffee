angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (
    SimpleTableDelegate
    TableHeader
    TableSort
  ) ->

    data = fixtures()
    {sort} = TableSort

    @tableDelegate = SimpleTableDelegate
      headers: [
        TableHeader
          name: 'Id'
          sortField: 'id'
          width: '100px'

        TableHeader
          name: 'Name'
          sortField: 'name'
          sortActive: true

        TableHeader
          name: 'Email Address'
          sortField: 'email'
      ]

      fetchData: ({sortHeader}, updateData) ->
        sortedData = sort data, sortHeader
        updateData {data: sortedData, totalItems: sortedData.length}

    @visibleColumns = [true, true, true]

    @toggleColumn = (columnNumber) ->
      index = columnNumber - 1
      @visibleColumns[index] = !@visibleColumns[index]
      @tableDelegate.setVisibleColumns(@visibleColumns)

    return

fixtures = ->
  celebrities = [
    {id: 1, name: "Jose Valim",  email: "josevalim@gmail.com"}
    {id: 2, name: "Dan Abramov", email: "dan_abramov@clio.com"}
    {id: 3, name: "Todd Motto",  email: "toddmotto@live.com"}
    {id: 4, name: "Yehuda Katz", email: "wycats@gmail.com"}
    {id: 10, name: "Paul Graham", email: "paulg@verizon.net"}
  ]

  return celebrities
