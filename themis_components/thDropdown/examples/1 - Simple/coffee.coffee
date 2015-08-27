angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @links = [
      { name: "Link One", url: "#" }
      { name: "Link Two", url: "#" }
      { name: "Link Three", url: "#" }
    ]
    return
