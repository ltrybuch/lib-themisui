angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", ->
    @tableDelegate = new Object
      data: [
        { name: "Jose Valim", twitter: "twitter.com/josevalim" }
        { name: "Dan Abramov", twitter: "twitter.com/dan_abramov" }
        { name: "Todd Motto", twitter: "twitter.com/toddmotto" }
        { name: "Yehuda Katz", twitter: "twitter.com/wycats" }
      ]

      headers: [
        new Object
          name: 'Name'

        new Object
          name: 'Twitter'
      ]

    return
