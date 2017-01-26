angular.module("thTabsetDemo")
  .controller "thTabsetDemoCtrl4", ->
    @tabOptions = [
      {name: "Tab One", value: "Tab One"}
      {name: "Tab Two", value: "Tab Two"}
      {name: "Tab Three", value: "Tab Three"}
      {name: "Tab Four", value: "Tab Four"}
      {name: "Tab Five", value: "Tab Five"}
    ]
    @currentTab = @tabOptions[0]
    @updateSelect = (option) -> @currentTab = @tabOptions[option]

    return
