angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", (SimpleTableDelegate, TableHeader) ->
    @tableDelegate = new SimpleTableDelegate
      data: [
        { name: "Jose Valim",  twitter: "http://twitter.com/josevalim" }
        { name: "Dan Abramov", twitter: "http://twitter.com/dan_abramov" }
        { name: "Todd Motto",  twitter: "http://twitter.com/toddmotto" }
        { name: "Yehuda Katz", twitter: "http://twitter.com/wycats" }
      ]

      headers: [
        new TableHeader
          name: 'Name'

        new TableHeader
          name: 'Twitter'
      ]

    return
