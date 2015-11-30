angular.module('ThemisComponents')
  .directive "thCheckbox", ->
    restrict: "EA"
    replace: true
    template: require './thCheckbox.template.html'
    scope:
      checked: '=ngModel'
    bindToController: true
    controllerAs: 'checkbox'
    controller: checkboxController

checkboxController = ->
  @checked = @checked ? false
  @toggle = -> @checked = not @checked

  return
