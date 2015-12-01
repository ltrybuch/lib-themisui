angular.module('ThemisComponents')
  .directive "thCheckbox", ->
    restrict: "EA"
    replace: true
    template: """
      <span
        class="th-checkbox"
        ng-class="{checked: checkbox.checked}"
        >
        <input
          type="checkbox"
          name="{{checkbox.name}}"
          ng-model="checkbox.checked"
          >
        <i></i>
      </span>
    """
    scope:
      name: '@'
      change: '&ngChange'
      checked: '=ngModel'
    bindToController: true
    controllerAs: 'checkbox'
    controller: checkboxController

checkboxController = ($scope, $element) ->
  @checked = @checked ? false

  @toggle = ->
    $scope.$apply =>
      @checked = not @checked
    @change() if @change?

  $element.on 'click', =>
    @toggle()

  return
