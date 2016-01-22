angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @options = [
      {name: "Identity...", value: null}
      {name: "Batman", group: "DC", value: "Bruce Wayne"}
      {name: "Supeman", group: "DC", value: "Clark Kent"}
      {name: "Spider-Man", group: "Marvel", value: "Peter Parker"}
      {name: "Captain America", group: "Marvel", value: "Steve Rogers"}
    ]
    @model = @options[0]
    return
