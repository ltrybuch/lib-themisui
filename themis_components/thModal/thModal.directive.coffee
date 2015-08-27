angular.module('ThemisComponents')
  .directive "thModal", ->
    restrict: "EA"
    replace: true
    controllerAs: "modal"
    bindToController: true
    scope:
      modalData: "="
    template: """
      <div class="th-modal {{ modal.name }}">
        <div th-compile="modal.content"></div>
      </div>
    """
    controller: (ModalManager) ->
      @name = @modalData.name
      @content = @modalData.content

      @dismiss = (response) ->
        ModalManager.dismiss @name, response

      @confirm = (response) ->
        ModalManager.confirm @name, response

      return

