angular.module('ThemisComponents')
  .directive "thRadioButton", ->
    require: '^thRadioGroup'
    restrict: "EA"
    replace: true
    template: require './thRadioButton.template.html'
    scope:
      value: '@'
      change: '&ngChange'
    link: (scope, element, attrs, controller) ->
      scope.group = controller

      element.on 'click', (event) ->
        scope.group.selectButton scope

      return
