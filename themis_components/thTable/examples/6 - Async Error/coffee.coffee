angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (SimpleTableDelegate, TableHeader, $scope) ->
    attempts = 2
    getData = ->
      data = [
        {id: 1, name: 'Tom'}
        {id: 2, name: 'Jane'}
        {id: 3, name: 'Jax'}
      ]
      attempts--
      if attempts > 0 then {error: true} else {data}

    @tableDelegate = SimpleTableDelegate {
      headers: [
        TableHeader
          name: 'Id'

        TableHeader
          name: 'Name'
      ]

      fetchData: (page, pageSize, sortHeader, updateData) ->
        setTimeout ->
          {error, data} = getData()
          updateData error, data
          $scope.$apply()
        , 1000
    }

    return
