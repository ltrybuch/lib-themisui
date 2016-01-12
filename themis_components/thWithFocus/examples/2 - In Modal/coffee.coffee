angular.module("thDemo", ["ThemisComponents"])
  .controller "DemoController", (ModalManager) ->
    @path = 'exampleTemplates/thWithFocusExampleTemplate.html'

    @displayModal = ->
      ModalManager.show path: @path
    return
