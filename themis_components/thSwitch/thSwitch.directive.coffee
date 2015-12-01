angular.module('ThemisComponents')
  .directive "thSwitch", ->
    restrict: "EA"
    replace: true
    template: """
      <span
        class="th-switch"
        ng-class="{active: switch.state}"
        >
        <input
          type="checkbox"
          name="{{switch.name}}"
          ng-model="switch.state"
          >
        <i></i>
      </span>
    """
    scope:
      name: '@'
      change: '&ngChange'
      state: '=ngModel'
    bindToController: true
    controllerAs: 'switch'
    controller: ($scope, $element) ->
      @state = @state ? off

      @toggle = ->
        $scope.$apply =>
          @state = not @state
        @change() if @change?

      $element.on 'click', =>
        @toggle()

      return
