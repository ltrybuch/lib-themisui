angular.module('ThemisComponents')
  .directive "thSwitch", ->
    restrict: "EA"
    replace: true
    template: require('./thSwitch.template.html')
    scope:
      name: '@'
      change: '&ngChange'
      state: '=ngModel'
      ngRequired: "="
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
