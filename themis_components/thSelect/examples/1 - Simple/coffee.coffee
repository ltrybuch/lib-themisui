angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @options = [
      { text: "One", value: 1 }
      { text: "Two", value: 2 }
      { text: "Three", value: 3 }
    ]
    return
