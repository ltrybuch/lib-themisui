angular.module("thModalDemo")
  .controller "thModalDemoCtrl3", (ModalManager) ->
    @path = "/components/thModal/examples/3 - Prompt/thModalExampleTemplate.html"
    @user =
      name: "stranger"

    @displayModal = ->
      ModalManager.show path: @path, name: "prompt"
        .then (response) =>
          @user.name = response

    return
