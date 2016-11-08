angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (
    SimpleTableDelegate
    TableHeader
    TableSort
    FilterSet
  ) ->
    filterTypes = [
      {
        name: 'Tier'
        type: 'select'
        fieldIdentifier: 'tier'
        placeholder: 'Select an option'
        selectOptions: [
          {name: 'One', value: 'one'}
          {name: 'Two', value: 'two'}
          {name: 'Three', value: 'three'}
        ]
      }
      {
        name: 'Difficulty'
        type: 'select'
        fieldIdentifier: 'difficulty'
        placeholder: 'Select an option'
        selectOptions: [
          {name: 'Easy', value: 'easy'}
          {name: 'Medium', value: 'medium'}
          {name: 'Hard', value: 'hard'}
        ]
      }
      {
        name: 'Status'
        type: 'select'
        fieldIdentifier: 'status'
        placeholder: 'Select an option'
        selectOptions: [
          {name: 'Open', value: 'open'}
          {name: 'Closed', value: 'closed'}
          {name: 'Pending', value: 'pending'}
        ]
      }
    ]

    {sort} = TableSort
    data = fixtures 10, filterTypes

    @filterSet = new FilterSet
      onFilterChange: =>
        @tableDelegate.reload {currentPage: 1}

    @filterOptions = {
      filterSet: @filterSet
      customFilterTypes: filterTypes
    }

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
          name: 'Tier'
          sortField: 'tier'

        TableHeader
          name: 'Difficulty'
          sortField: 'difficulty'

        TableHeader
          name: 'Status'
          sortField: 'status'
      ]

      fetchData: ({sortHeader}, updateData) =>
        filteredData = data
        for filter in @filterSet
          state = filter.getState()
          if state?
            filteredData = filteredData.filter (item) ->
              item[filter.fieldIdentifier] is state.value

        sortedData = sort filteredData, sortHeader
        updateData {data: sortedData, totalItems: sortedData.length}

    return

fixtures = (length, types) ->
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

  data = []
  for i in [1 .. length]
    item =
      id: i
      name: generateName()

    for type in types
      item[type.fieldIdentifier] = type.selectOptions[getRandomInt(
        0, type.selectOptions.length - 1
      )].value

    data.push item

  return data
