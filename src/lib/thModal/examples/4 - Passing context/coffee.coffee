angular.module("thModalDemo")
  .controller "thModalDemoCtrl4", (ModalManager) ->
    @path = "/components/thModal/examples/4 - Passing context/thModalExampleTemplate.html"
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
