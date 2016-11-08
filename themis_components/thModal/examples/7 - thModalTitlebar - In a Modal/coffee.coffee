angular.module("thDemo", ["ThemisComponents"])
  .controller "DemoController", (ModalManager) ->
    @path = 'exampleTemplates/thModalExampleTemplate.html'

    titleString = "In a Model"
    template = """
      <div>
        <th-modal-titlebar title="Example Titlebar"></th-modal-titlebar>
        <p>
          Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod
          tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,
          quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo
          consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse
          cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non
          proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
        </p>
        <div class="actions">
          <th-button ng-click="modal.dismiss()">close</th-button>
        </div>
      </div>
    """

    @displayModal = =>
      ModalManager.show template: template, context: title: titleString
    return
