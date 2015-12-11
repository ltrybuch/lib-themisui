angular.module('ThemisComponents')
  .directive "thRadioButton", ->
    require: '^thRadioGroup'
    restrict: "EA"
    replace: true
    template: require './thRadioButton.template.html'
    scope:
      value: '@'
    link: (scope, element, attrs, controller) ->
      scope.parent = controller

      element.on 'click', ->
        scope.$apply ->
          scope.parent.model = scope.value

      return
