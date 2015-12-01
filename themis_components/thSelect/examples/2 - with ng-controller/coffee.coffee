angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @options = [
      {name: "Identity...", value: null}
      {name: "Batman", value: "Bruce Wayne"}
      {name: "Supeman", value: "Clark Kent"}
      {name: "Spider-Man", value: "Peter Parker"}
      {name: "Captain America", value: "Steve Rogers"}
    ]
    @model = @options[0]
    return
