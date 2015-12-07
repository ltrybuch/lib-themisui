angular.module('ThemisComponents')
  .directive "thSwitch", ->
    restrict: "EA"
    replace: true
    template: require('./thSwitch.template.html')
    scope:
      state: '=ngModel'
    bindToController: true
    controllerAs: 'switch'
    controller: ->
      @state = @state ? off
      @toggle = -> @state = not @state

      return
