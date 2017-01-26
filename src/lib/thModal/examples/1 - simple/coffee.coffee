angular.module("thModalDemo")
  .controller "thModalDemoCtrl1", (ModalManager) ->
    @path = "/components/thModal/examples/1 - simple/thModalExampleTemplate.html"

    @displayModal = =>
      ModalManager.show path: @path
    return
