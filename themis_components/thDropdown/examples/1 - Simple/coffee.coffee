angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @genres = [
      { name: "Action", url: "#" }
      { name: "Science Fiction", url: "#" }
      { name: "Drama", url: "#" }
    ]
    @settings = [
      { name: "Name", url: "#" }
      { name: "Avatar", url: "#" }
      { name: "Address", url: "#" }
    ]
    return
