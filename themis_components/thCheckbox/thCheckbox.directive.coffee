angular.module('ThemisComponents')
  .directive "thCheckbox", ->
    restrict: "EA"
    replace: true
    template: """
      <span
        ng-class="{checked: checkbox.checked}"
        class="th-checkbox"
        ng-click="checkbox.toggle()"
        >
        <i></i>
      </span>
    """
    scope:
      state: '=ngModel'
    bindToController: true
    controllerAs: 'checkbox'
    controller: ->
      @checked = @checked ? false
      @toggle = -> @checked = not @checked

      return