angular.module("thSelectDemo")
  .controller "thSelectDemoCtrl4", ->

    @options = [
      {name: "No", value: 0}
      {name: "Maybe", value: 1}
      {name: "Yes", value: 2}
    ]
    @model = @options[1]
    @disabled = on
    @toggle = -> @disabled = !@disabled
    return
