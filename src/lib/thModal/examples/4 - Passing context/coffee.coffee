angular.module("thDemo", ["ThemisComponents"])
  .controller "DemoController", (ModalManager) ->
    @path = "exampleTemplates/thModalExampleTemplate4.html"
    @fromModal = {}
    @user =
      user:
        firstName: "Clark"
        lastName: "Kent"
        email: "clark.kent@dailyplanet.dc"

    @displayModal = =>
      ModalManager.show path: @path, name: "prompt", context: @user
        .then (data) =>
          @fromModal = data
    return
