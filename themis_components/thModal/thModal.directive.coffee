angular.module('ThemisComponents')
  .directive "thModal", (ModalManager) ->
    restrict: "EA"
    replace: true
    controllerAs: "ctrl"
    transclude: true
    bindToController: true
    scope:
      name: "="
      path: "="
      params: "="
      content: "="
    template: """
      <div class="th-modal-backdrop" ng-class="{visible: ctrl.modals.length > 0}">
        <div class="th-modal-container" ng-repeat="modal in ctrl.modals | limitTo:1">
          <div class="cell">
            <div class="th-modal {{ modal.name }}">
                <div class="ui-close" ng-click="ctrl.dismiss(modal.name)"></div>
              <div style="clear: both;"></div>
              <div th-compile="modal.content"></div>
            </div>
          </div>
        </div>
      </div>
    """
    link: (scope, element, attrs, ctrl, transclude) ->
      prelink:
        transclude (transEl) ->
          # let's see if anything is passed in
          if transEl.length > 0

            # concat elements into clean string
            content = ""
            for el in transEl
              html = el.outerHTML
              if html
                content += html

            # add to the modal queue
            ModalManager.addToQueue
              name: ctrl.name
              content: content

    controller: ->
      # if no src path is passed in we'll let it be transcluded
      if @path
        ModalManager.add(@path, @params ? {}, @name)

      @modals = ModalManager.modals

      @dismiss = (name) ->
        ModalManager.removeModal(name)

      return
