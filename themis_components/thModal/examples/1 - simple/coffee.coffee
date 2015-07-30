angular.module("thDemo", ["ThemisComponents"])
  .controller "DemoController", (ModalManager) ->
    @path = 'exampleTemplates/thModalExampleTemplate.html'

    @displayModal = =>
      ModalManager.showModal(path: @path)

    return
