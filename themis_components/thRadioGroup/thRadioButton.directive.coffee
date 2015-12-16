angular.module('ThemisComponents')
  .directive "thRadioButton", ->
    require: '^thRadioGroup'
    restrict: "EA"
    replace: true
    template: require './thRadioButton.template.html'
    scope:
      value: '@'
      change: '&ngChange'
    link: (scope, element, attrs, group) ->
      scope.group = group

      group.addButton scope, attrs['checked']?

      element.on 'click', ->
        group.selectButton scope

      return
