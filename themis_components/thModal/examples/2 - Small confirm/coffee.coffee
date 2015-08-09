angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', (ModalManager) ->
    @state = off
    @modal =
      path: "exampleTemplates/thModalExampleTemplate2.html"
      name: "first-template"

    @displayModal = =>
      ModalManager.showModal(path: @modal.path, name: @modal.name)
      .then (response) =>
        @state = on
      , (response) =>
        @state = off
        console.log response

    return
