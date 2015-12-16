angular.module('ThemisComponents')
  .directive "thRadioButton", ->
    require: '^thRadioGroup'
    restrict: "EA"
    replace: true
    template: require './thRadioButton.template.html'
    scope:
      value: '@'
      change: '&ngChange'
    link: (scope, element, attrs, radioGroup) ->
      radioGroup.addButton scope, attrs['checked']?

      scope.group = radioGroup
      element.on 'click', ->
        scope.group.selectButton scope

      return
