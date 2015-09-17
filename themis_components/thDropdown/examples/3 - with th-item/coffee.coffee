angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @links = [
      { name: "From Ctrl: Link", url: "#" }
      { name: "From Ctrl: Link", url: "#" }
    ]
    return
