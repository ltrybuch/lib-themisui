angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @data = {}
    @data.options = [
      { name: "Identity...", value: null }
      { name: "Batman", value: "Bruce Wayne" }
      { name: "Supeman", value: "Clarke Kent" }
      { name: "Spider-Man", value: "Peter Parker" }
      { name: "Captain America", value: "Steve Rogers" }
    ]
    @data.model = @data.options[0]
    return
