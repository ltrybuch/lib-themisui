angular.module("thSelectDemo")
  .controller "thSelectDemoCtrl2", ->

    @options = [
      {name: "Batman", group: "DC", value: "Bruce Wayne"}
      {name: "Superman", group: "DC", value: "Clark Kent"}
      {name: "Spider-Man", group: "Marvel", value: "Peter Parker"}
      {name: "Captain America", group: "Marvel", value: "Steve Rogers"}
    ]
    return
