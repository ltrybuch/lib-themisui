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
      letterSpacing: "<"
    link: (scope, element, attrs, controller) ->
      scope.active = no
      scope.ariaControlsID = scope.name.replace(/\s+/g, '-').toLowerCase() + "-tab"
      controller.addTab scope
