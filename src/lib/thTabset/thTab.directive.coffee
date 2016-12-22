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
      show: "<"
      badge: "<"
      letterSpacing: "<"
    link: (scope, element, attrs, controller) ->
      scope.show ?= yes
      scope.active = no

      scope.$watch ->
        scope.show
      , (isVisible) ->
        if isVisible
          controller.setActiveIfOnlyVisibleTab scope
        else
          controller.setNextActiveTab scope

      scope.ariaControlsID = scope.name.replace(/\s+/g, '-').toLowerCase() + "-tab"
      controller.addTab scope
