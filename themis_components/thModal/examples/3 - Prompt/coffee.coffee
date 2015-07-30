angular.module("thDemo", ["ThemisComponents"])
  .controller "DemoController", (ModalManager) ->
    @path = "exampleTemplates/thModalExampleTemplate3.html"
    @user =
      name: "stranger"

    @displayModal = ->
      ModalManager.showModal(path: @path, name: "prompt").then (response) =>
        @user.name = response

    return
