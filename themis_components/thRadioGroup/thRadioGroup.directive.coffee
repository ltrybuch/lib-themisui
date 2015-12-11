angular.module('ThemisComponents')
  .directive 'thRadioGroup', ->
    restrict: 'EA'
    replace: true
    transclude: true
    bindToController: true
    controllerAs: "radioGroup"
    template: require './thRadioGroup.template.html'
    scope:
      name: '@'
      type: '@'
      model: '=ngModel'
    controller: ($scope) ->
      return
