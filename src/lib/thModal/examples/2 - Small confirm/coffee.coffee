angular.module('thDemo', ['ThemisComponents'])
  .controller 'DemoController', (ModalManager) ->
    @state = off
    @modal =
      path: "exampleTemplates/thModalExampleTemplate2.html"
      name: "first-template"

    @displayModal = =>
      ModalManager.show path: @modal.path, name: @modal.name
      .then (response) =>
        @state = on
      , (response) =>
        @state = off

    return

  # The confirm controller is bubbling up the scope to call the modals confirm / dismiss function
  # Unnecessary in this situation. Just a simple example
  .controller "ConfirmModalController", ($scope) ->
    @yes = ->
      $scope.modal.confirm("yes")
    @no = ->
      $scope.modal.dismiss("no")

    return
