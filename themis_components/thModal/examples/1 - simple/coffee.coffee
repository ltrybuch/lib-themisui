angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', (ModalManager) ->
    @modal =
      path: "exampleTemplates/thModalExampleTemplate.html"
      name: "first-template"

    @displayModal = =>
      ModalManager.showModal(@modal.path, {}, @modal.name)
    return
