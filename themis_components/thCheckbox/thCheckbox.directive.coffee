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
      checked: '=?ngModel'
    bindToController: true
    controllerAs: 'checkbox'
    controller: checkboxController

checkboxController = ->
  @checked = @checked ? false
  @toggle = -> @checked = not @checked

  return
