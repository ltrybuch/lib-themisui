angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @options = [
      {name: "Identity...", value: null}
      {name: "Canada", group: "North America", value: "can"}
      {name: "United States", group: "North America", value: "usa"}
      {name: "Mexico", group: "North America", value: "mex"}
      {name: "Argentina", group: "South America", value: "arg"}
      {name: "Chile", group: "South America", value: "chl"}
      {name: "Brazil", group: "South America", value: "bra"}
    ]
    @model = @options[0]
    @counter = 0
    @onChange = ->
      @counter = @counter + 1
    return
