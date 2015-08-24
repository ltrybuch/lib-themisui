angular.module("thDemo", ["ThemisComponents"])
  .controller "DemoController", (ModalManager) ->
    @path = 'exampleTemplates/thModalExampleTemplate.html'

    @displayModal = =>
      ModalManager.show(path: @path)

    return
