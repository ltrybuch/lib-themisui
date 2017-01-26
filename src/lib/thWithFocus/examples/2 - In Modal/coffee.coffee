angular.module("thWithFocusDemo")
  .controller "thWithFocusDemoCtrl2", (ModalManager) ->
    @path = "/components/thWithFocus/examples/2 - In Modal/thWithFocusExampleTemplate.html"
    @displayModal = ->
      ModalManager.show path: @path
    return
