angular.module('ThemisComponents')
  .directive "thSwitch", ->
    restrict: "EA"
    replace: true
    template: """
      <span
        class="th-switch"
        ng-class="{active: switch.state}"
        href=""
        ng-click="switch.toggle()"
        >
        <i></i>
      </span>
    """
    scope:
      state: '=ngModel'
    bindToController: true
    controllerAs: 'switch'
    controller: ->
      @state = @state ? off
      @toggle = -> @state = not @state

      return
