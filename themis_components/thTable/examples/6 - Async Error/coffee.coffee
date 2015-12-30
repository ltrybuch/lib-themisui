angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (SimpleTableDelegate, TableHeader, $timeout) ->
    @attempts = 3

    getData = =>
      data = [
        {id: 1, name: 'Tom'}
        {id: 2, name: 'Jane'}
        {id: 3, name: 'Jax'}
      ]
      @attempts--
      if @attempts > 0 then {error: true} else {data}

    @tableDelegate = SimpleTableDelegate
      headers: [
        TableHeader
          name: 'Id'

        TableHeader
          name: 'Name'
      ]

      fetchData: (options, updateData) ->
        $timeout ->
          updateData getData()
        , 1000

    return
