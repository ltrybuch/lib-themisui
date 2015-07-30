angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', (ModalManager) ->
    @state = off
    @modal =
      path: "exampleTemplates/thModalExampleTemplate.html"
      name: "first-template"

    @displayModal = =>
      ModalManager.show(@modal.path, {}, @modal.name, {size: 'sm'})
      .then (response) =>
        @state = on
      , => @state = off

    return
