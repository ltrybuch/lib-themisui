angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (SimpleTableDelegate, TableHeader) ->
    reveal = false

    @revealData = =>
      reveal = true
      @tableDelegate.triggerFetchData()

    getData = ->
      data = [
        {id: 1, name: 'Tom'}
        {id: 2, name: 'Jane'}
        {id: 3, name: 'Jax'}
      ]
      if reveal then data else []

    @tableDelegate = SimpleTableDelegate {
      headers: [
        TableHeader
          name: 'Id'

        TableHeader
          name: 'Name'
      ]

      fetchData: (page, pageSize, sortHeader, updateData) ->
        updateData undefined, getData()
    }

    return
