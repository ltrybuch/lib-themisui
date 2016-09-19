angular
  .module('ThemisComponents')
  .directive "thTab", ->
    require: "^thTabset"
    restrict: "EA"
    template: require './thTab.template.html'
    transclude: true
    scope:
      name: "@name"
      ngClick: "&"
      badge: "<"
    link: (scope, element, attrs, controller) ->
      scope.active = no
      controller.addTab scope
