angular.module('ThemisComponents')
  .directive "thModal", ->
    restrict: "EA"
    replace: true
    controllerAs: "modal"
    bindToController: true
    scope:
      modalData: "="
    template: """
      <div class="th-modal {{ modal.name }}"
        ng-class="{'modal-sm': modal.size == 'sm'}"
        >
        <div th-compile="modal.content"></div>
      </div>
    """
    controller: (ModalManager) ->
      @name = @modalData.name
      @content = @modalData.content
      @size = @modalData.size

      @dismiss = ->
        ModalManager.dismiss @name

      @confirm = (args) ->
        ModalManager.confirm @name, args

      return

