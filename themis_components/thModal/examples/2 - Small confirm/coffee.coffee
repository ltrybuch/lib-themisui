angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', (ModalManager) ->
    @state = off
    @modal =
      path: "exampleTemplates/thModalExampleTemplate2.html"
      name: "first-template"

    @displayModal = =>
      ModalManager.show(path: @modal.path, name: @modal.name)
      .then (response) =>
        @state = on
      , (response) =>
        @state = off

    return
