angular.module("thTableDemo")
  .controller "thTableDemoCtrl7", (SimpleTableDelegate, TableHeader) ->
    @tableDelegate = SimpleTableDelegate
      headers: [
        TableHeader
          name: 'Id'

        TableHeader
          name: 'Name'
      ]

      fetchData: (options, updateData) -> return

    return
