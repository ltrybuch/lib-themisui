angular.module('ThemisComponents')
  .directive "thSwitch", ->
    restrict: "EA"
    scope:
      state: '=ngModel'
    replace: true
    template: """
      <a
        class="th-switch"
        ng-class="{active:state}"
        href=""
        ng-click="toggle()"
        >

        <i></i>
      </a>
    """
    controller: ($scope) ->
      $scope.state = off unless $scope.state

      $scope.toggle = -> $scope.state = not $scope.state
