angular.module 'thDemo', ['ThemisComponents']
  .controller "DemoController", ->
    @people = [
      { name: "Jose Valim", twitter: "twitter.com/josevalim" }
      { name: "Dan Abramov", twitter: "twitter.com/dan_abramov" }
      { name: "Todd Motto", twitter: "twitter.com/toddmotto" }
      { name: "Yehuda Katz", twitter: "twitter.com/wycats" }
    ]

    return
