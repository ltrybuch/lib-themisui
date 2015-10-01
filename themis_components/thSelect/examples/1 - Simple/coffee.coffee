angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @data = {}
    @data.options = [
      { name: "placeholder...", value: "" }
      { name: "Corporate", value: 1 }
      { name: "Criminal", value: 2 }
      { name: "Employment", value: 3 }
      { name: "Family", value: 4 }
    ]
    @data.model = @data.options[1]
    return
