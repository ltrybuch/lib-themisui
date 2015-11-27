angular.module('ThemisComponents')
  .directive "thModal", ->
    restrict: "EA"
    replace: true
    controllerAs: "modal"
    bindToController: true
    scope:
      modalData: "="
    template: require './thModal.template.html'
    controller: (ModalManager) ->
      @name = @modalData.name
      @content = @modalData.content

      @dismiss = (response) ->
        ModalManager.dismiss @name, response

      @confirm = (response) ->
        ModalManager.confirm @name, response

      return

