angular.module('thDemo', ['ThemisComponents'])
  .controller "DemoController", ->
    @options = [
      {name: "Canada", group: "North America", value: "can"}
      {name: "United States", group: "North America", value: "usa"}
      {name: "Mexico", group: "North America", value: "mex"}
      {name: "Argentina", group: "South America", value: "arg"}
      {name: "Chile", group: "South America", value: "chl"}
      {name: "Brazil", group: "South America", value: "bra"}
      {name: "Democratic People's Republic of Korea", group: "Asia", value: "dprk"}
    ]
    @counter = 0
    @onChange = -> @counter = @counter + 1
    return
